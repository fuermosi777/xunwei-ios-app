//
//  HomeViewController.m
//  寻味
//
//  Created by Hao Liu on 11/19/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#define NAVIGATIONHEIGHT 64
#define LISTITEMHEIGHT 80
#define MAPHEIGHT 80
#define NAVBARHEIGHT 40
#define ADHEIGHT 80

#import "HomeViewController.h"
#import "ListItemView.h"
#import "DetailViewController.h"
#import <MapKit/MapKit.h>
#import "MapViewController.h"
#import "UserTableViewController.h"
#import "SigninTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <NYXImagesKit/NYXImagesKit.h>
#import "SelectorScrollView.h"
#import "AdScrollView.h"
#import <MBProgressHUD/MBProgressHUD.h> // progress indicator
#import "SearchViewController.h"
#import "AlertView.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidAppear:(BOOL)animated {
    [self resetAvatar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self locateSelf];
    [self addRightButton];
    [self addMapSnapshot];
    [self addSearchField];
    [self addNavbar];
    [self addAd];
    [self addTable];
    
    [self addAvatar];
    
    // notification center
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectButtonTapped:)
                                                 name:@"SelectButtonTappedNotification"
                                               object:nil];
}

#pragma mark - Location

- (void)locateSelf {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];
    
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self.locationManager stopUpdatingLocation];
    _currentLocation = newLocation;
    [self loadData:[NSString stringWithFormat:@"http://xun-wei.com/app/restaurants/?amount=30&lng=%f&lat=%f&span=%f",newLocation.coordinate.longitude,newLocation.coordinate.latitude,0.05]];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
    AlertView *alert = [[AlertView alloc] init];
    [alert showCustomErrorWithTitle:@"错误" message:@"无法定位您的位置，请确保寻味的定位许可已经开启" cancelButton:@"好的"];
}

#pragma mark - action

- (void)selectButtonTapped:(NSNotification *)notification {
    if ([[notification name] isEqualToString:@"SelectButtonTappedNotification"]){
        UIButton *button = (UIButton *) notification.object;
        if (![button.titleLabel.text isEqual:@"附近"]){
            [self loadData:[NSString stringWithFormat:@"http://xun-wei.com/app/restaurants/?amount=30&keyword=%@&lat=%f&lng=%f&span=0.05", button.titleLabel.text, _currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude]];
        } else {
            [_locationManager startUpdatingLocation];
        }
    }
}

- (void)resetAvatar {
    if (self.checkLoginStatus && !_avatarImage) {
        // get url
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *dict = [userInfo objectForKey:@"userinfo"];
        NSURL *photo_URL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"avatar"]]];
        
        // load image
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:photo_URL
                                                            options:0
                                                           progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                               // progression tracking code
                                                           }
                                                          completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                              if (image && finished) {
                                                                  _avatar.image = image;
                                                              }
                                                          }];
    } else {
        _avatar.image = [UIImage imageNamed:@"orange-face"];
    }
}

- (void)addAvatar {
    // navigationbar
    _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    UIBarButtonItem *avatarItem = [[UIBarButtonItem alloc] initWithCustomView:_avatar];
    
    self.navigationController.navigationBar.topItem.leftBarButtonItem = avatarItem;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseUserOrSignin)];
    [_avatar addGestureRecognizer:tap];
    [_avatar setUserInteractionEnabled:YES];
    [_avatar.layer setCornerRadius:12.0];
    [_avatar setClipsToBounds:YES];
}

- (void)removeAvatar {
    [_avatar removeFromSuperview];
    _avatar = nil;
}

- (void)chooseUserOrSignin {
    if (self.checkLoginStatus) {
        [self redirectToUserView];
    } else {
        [self redirectToSigninView];
    }
}

- (void)redirectToUserView {
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSString *username = [userInfo objectForKey:@"username"];
    
    UserTableViewController *userVC = [[UserTableViewController alloc] initWithUsername:username];
    [self.navigationController pushViewController:userVC animated:YES];
}

- (void)redirectToSigninView {
    SigninTableViewController *vc = [[SigninTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)reloadView {
    [_locationManager startUpdatingLocation];
}

- (void)addRightButton {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"] landscapeImagePhone:nil
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(reloadView)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

# pragma mark - scroll event
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y - _lastContentOffset > 10.0) { // scroll down
        [self hideNav];
    } else if (_lastContentOffset - scrollView.contentOffset.y > 5.0 && scrollView.contentOffset.y <= 0) {
        [self unhideNav];
    }
    
    _lastContentOffset = scrollView.contentOffset.y;
}

- (void)hideNav {
    [UIView animateWithDuration:0.2
                     animations:^{
                         [_mapSnapshotView setFrame:CGRectMake(0, -100, _mapSnapshotView.frame.size.width, _mapSnapshotView.frame.size.height)];
                         [_navScrollView setFrame:CGRectMake(0, 64, self.view.frame.size.width, 40)];
                         [_tableView setFrame:CGRectMake(0, NAVBARHEIGHT + NAVIGATIONHEIGHT, self.view.frame.size.width, self.view.frame.size.height - NAVIGATIONHEIGHT - NAVBARHEIGHT)];
                         [_adScrollView setFrame:CGRectMake(0, -100, _adScrollView.frame.size.width, ADHEIGHT)];
                         
                     }];
}

- (void)unhideNav {
    [UIView animateWithDuration:0.2
                     animations:^{
                         [_mapSnapshotView setFrame:CGRectMake(0, NAVIGATIONHEIGHT + ADHEIGHT, _mapSnapshotView.frame.size.width, _mapSnapshotView.frame.size.height)];
                         [_navScrollView setFrame:CGRectMake(0, MAPHEIGHT + NAVIGATIONHEIGHT + ADHEIGHT, self.view.frame.size.width, NAVBARHEIGHT)];
                         [_tableView setFrame:CGRectMake(0, ADHEIGHT + MAPHEIGHT + NAVBARHEIGHT + NAVIGATIONHEIGHT, self.view.frame.size.width, self.view.frame.size.height - ADHEIGHT - MAPHEIGHT - NAVBARHEIGHT - NAVIGATIONHEIGHT)];
                         [_adScrollView setFrame:CGRectMake(0, NAVIGATIONHEIGHT, _adScrollView.frame.size.width, ADHEIGHT)];
                     }];
}

# pragma mark - add

- (void)addSearchField {
    // add search box
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 130, 26)];
    textField.backgroundColor = [UIColor whiteColor];
    textField.textColor = [UIColor grayColor];
    textField.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
    textField.layer.cornerRadius = 13.0f;
    textField.delegate = self;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"开始寻味"
                                                                      attributes:@{
                                                                                   NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                                                                   NSFontAttributeName : [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14.0],
                                                                                   }
                                       ];
    // add search icon
    UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(7, 5, 15, 15)];
    [searchIcon setImage:[UIImage imageNamed:@"search"]];
    [textField addSubview:searchIcon];
    
    self.navigationController.navigationBar.topItem.titleView = textField;
}

- (void)addMapSnapshot {
    // create snap shot block and add it to the view
    _mapSnapshotView = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVIGATIONHEIGHT + ADHEIGHT, self.view.frame.size.width, MAPHEIGHT)];
    [self.view addSubview:_mapSnapshotView];
    
    // fill image into block
    [self snapshotMapView:_mapSnapshotView];
    
    // add transparent overlay
    UIView *overlay = [[UIView alloc] initWithFrame:_mapSnapshotView.bounds];
    [overlay setBackgroundColor:[UIColor colorWithRed:0.99 green:0.65 blue:0.18 alpha:0.6]];
    [_mapSnapshotView addSubview:overlay];
    
    // add address label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 16 , self.view.frame.size.width, 40)];
    label.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    label.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
    label.text = @"在地图上查看";
    label.textAlignment = NSTextAlignmentCenter;
    
    [overlay addSubview:label];
    
    // add click event
    UITapGestureRecognizer *awesomeViewSingleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(redirectToMapView)];
    [_mapSnapshotView addGestureRecognizer:awesomeViewSingleFingerTap];
    [_mapSnapshotView setUserInteractionEnabled:YES];
    
    
}

- (void)addAd {
    _adScrollView = [[AdScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATIONHEIGHT, self.view.frame.size.width, ADHEIGHT)];
    [_adScrollView setParentVC:self];
    [self.view addSubview:_adScrollView];
}

- (void)addNavbar {
    NSMutableArray *selectArray = [[NSMutableArray alloc] initWithObjects:@"附近", @"中餐", @"火锅", @"小吃", @"日料", @"韩餐", @"甜品", @"川菜", @"粤菜", nil];
    
    _navScrollView = [[SelectorScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATIONHEIGHT + MAPHEIGHT + ADHEIGHT, self.view.frame.size.width, NAVBARHEIGHT)
                                                         array:selectArray];
    
    [self.view addSubview:_navScrollView];
}

- (void)addTable {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATIONHEIGHT + MAPHEIGHT + NAVBARHEIGHT + ADHEIGHT, self.view.frame.size.width, self.view.frame.size.height - NAVIGATIONHEIGHT - MAPHEIGHT - NAVBARHEIGHT - ADHEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
}

#pragma mark - table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section
    return [_array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger rowHeight = LISTITEMHEIGHT;
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // edit cell
    NSMutableDictionary *dict = [_array objectAtIndex:indexPath.row];
    ListItemView *listItemView = [[ListItemView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, LISTITEMHEIGHT)
                                                          dataSource:dict];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(redirectToDetailView:)];
    listItemView.tag = [[dict objectForKey:@"id"] intValue];
    
    [listItemView addGestureRecognizer:tap];
    [listItemView setUserInteractionEnabled:YES];
    
    [cell addSubview:listItemView];
    return cell;
}

- (void)snapshotMapView:(UIImageView *)imageView {
    float latitude, longitude;
    if ([_array count] > 0) {
        NSDictionary *dict = [_array objectAtIndex:0];
        latitude = [[dict objectForKey:@"latitude"] floatValue];
        longitude = [[dict objectForKey:@"longitude"] floatValue];
    } else {
        latitude = 40.7242071;
        longitude = -73.9946707;
    }
    
    NSString *staticMapUrl = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?center=%f,%f&scale=2&zoom=15&size=%lix80&sensor=true",latitude, longitude,(long)(self.view.frame.size.width)];
    NSURL *mapUrl = [NSURL URLWithString:[staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:mapUrl]];
    imageView.image = image;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self redirectToSearchView];
    return NO;
}

- (void)redirectToSearchView {
    SearchViewController *vc = [[SearchViewController alloc] init];
    [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:^{}];
}

- (void)redirectToMapView {
    MapViewController *mapViewController = [[MapViewController alloc] init];
    // pass business detail info to vc
    [self.navigationController pushViewController:mapViewController animated:YES];
}

- (void)redirectToDetailView:(UITapGestureRecognizer *)tap {
    NSInteger ID = tap.view.tag;
    
    DetailViewController *vc = [[DetailViewController alloc] initWithID:ID];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadData:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // send url request
        NSString *urlString = [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlString];
        NSError *error;
        NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];

                NSError *error = nil;
                
                // 先输出array，然后第0位的才是dict
                NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:kNilOptions
                                                                          error:&error];
                
                // store to local
                NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
                [userInfo setValue:array forKey:@"restaurants"];
                [userInfo synchronize];
                
                // load complete
                [self loadComplete];
                
            });
        } else {
            [hud hide:YES];
            AlertView *alert = [[AlertView alloc] init];
            [alert showCustomErrorWithTitle:@"错误" message:@"请检查您的网络连接" cancelButton:@"好的"];
        }
        
    });
}

- (void)loadComplete {
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    _array = [userInfo objectForKey:@"restaurants"];
    if ([_array count] < 1) {
        AlertView *alert = [[AlertView alloc] init];
        [alert showCustomErrorWithTitle:@"抱歉" message:@"没有找到任何餐厅" cancelButton:@"好的"];
    }
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)checkLoginStatus {
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSString *username = [userInfo objectForKey:@"username"];
    if (username) {
        return YES;
    } else {
        return NO;
    }
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end