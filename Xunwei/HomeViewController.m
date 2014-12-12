//
//  HomeViewController.m
//  寻味
//
//  Created by Hao Liu on 11/19/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#define NAVIGATIONHEIGHT 64
#define LISTITEMHEIGHT 80
#define MAPHEIGHT 100
#define NAVBARHEIGHT 40
#define ADHEIGHT 80

#import "HomeViewController.h"
#import "GetRestaurants.h"
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

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidAppear:(BOOL)animated {
    [self resetAvatar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData:[NSString stringWithFormat:@"http://xun-wei.com/app/restaurants/?amount=30"]];
    [self addRightButton];
    [self addMapSnapshot];
    [self addNavbar];
    [self addAd];
    [self addTable];
    
    if (!_indicator) {
        [self initActivityIndicator];
    }
    
    [self addAvatar];
    
    // notification center
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectButtonTapped:)
                                                 name:@"SelectButtonTappedNotification"
                                               object:nil];
}

- (void)selectButtonTapped:(NSNotification *)notification {
    if ([[notification name] isEqualToString:@"SelectButtonTappedNotification"]){
        UIButton *button = (UIButton *) notification.object;
        if (![button.titleLabel.text isEqual:@"随便看看"]){
        [self loadData:[NSString stringWithFormat:@"http://xun-wei.com/app/restaurants/?amount=30&keyword=%@", button.titleLabel.text]];
        } else {
            [self loadData:[NSString stringWithFormat:@"http://xun-wei.com/app/restaurants/?amount=30"]];
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
                                                                  UIImage *imageScaled = [image scaleToFitSize:CGSizeMake(24, 24)];
                                                                  _avatar.image = imageScaled;
                                                              }
                                                          }];
    } else {
        _avatar.image = [UIImage imageNamed:@"orange-face"];
    }
}

- (void)addAvatar {
    // navigationbar
    _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    self.navigationController.navigationBar.topItem.titleView = _avatar;
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
    [self loadData:[NSString stringWithFormat:@"http://xun-wei.com/app/restaurants/?amount=30"]];
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
                         [_textField setFrame:CGRectMake(0, -100, _textField.frame.size.width, _textField.frame.size.height)];
                         [_navScrollView setFrame:CGRectMake(0, 64, self.view.frame.size.width, 40)];
                         [_tableView setFrame:CGRectMake(0, NAVBARHEIGHT + NAVIGATIONHEIGHT, self.view.frame.size.width, self.view.frame.size.height - NAVIGATIONHEIGHT - NAVBARHEIGHT)];
                         [_adScrollView setFrame:CGRectMake(0, -100, _adScrollView.frame.size.width, ADHEIGHT)];
                         
                     }];
}

- (void)unhideNav {
    [UIView animateWithDuration:0.2
                     animations:^{
                         [_mapSnapshotView setFrame:CGRectMake(0, NAVIGATIONHEIGHT + ADHEIGHT, _mapSnapshotView.frame.size.width, _mapSnapshotView.frame.size.height)];
                         [_textField setFrame:CGRectMake(30, 55 + NAVIGATIONHEIGHT + ADHEIGHT, self.view.frame.size.width - 60, 30)];
                         [_navScrollView setFrame:CGRectMake(0, MAPHEIGHT + NAVIGATIONHEIGHT + ADHEIGHT, self.view.frame.size.width, NAVBARHEIGHT)];
                         [_tableView setFrame:CGRectMake(0, ADHEIGHT + MAPHEIGHT + NAVBARHEIGHT + NAVIGATIONHEIGHT, self.view.frame.size.width, self.view.frame.size.height - ADHEIGHT - MAPHEIGHT - NAVBARHEIGHT - NAVIGATIONHEIGHT)];
                         [_adScrollView setFrame:CGRectMake(0, NAVIGATIONHEIGHT, _adScrollView.frame.size.width, ADHEIGHT)];
                     }];
}

# pragma mark - add

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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, 40)];
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
    
    // add search box
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(30, 55 + NAVIGATIONHEIGHT + ADHEIGHT, self.view.frame.size.width - 60, 30)];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.textColor = [UIColor grayColor];
    _textField.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
    _textField.layer.cornerRadius = 4.0f;
    _textField.delegate = self;
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"开始寻味"
                                                                       attributes:@{
                                                                                    NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                                                                    NSFontAttributeName : [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14.0],
                                                                                    }
                                        ];
    // add search icon
    UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 15, 15)];
    [searchIcon setImage:[UIImage imageNamed:@"search"]];
    [_textField addSubview:searchIcon];
    
    [self.view addSubview:_textField];
}

- (void)addAd {
    _adScrollView = [[AdScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATIONHEIGHT, self.view.frame.size.width, ADHEIGHT)];
    [_adScrollView setParentVC:self];
    [self.view addSubview:_adScrollView];
}

- (void)addNavbar {
    NSMutableArray *selectArray = [[NSMutableArray alloc] initWithObjects:@"随便看看", @"中餐", @"火锅", @"小吃", @"日料", @"韩餐", @"甜品", @"川菜", @"粤菜", nil];
    
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
    
    NSString *staticMapUrl = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?center=%f,%f&scale=2&zoom=15&size=%lix100&sensor=true",latitude, longitude,(long)(self.view.frame.size.width)];
    NSURL *mapUrl = [NSURL URLWithString:[staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:mapUrl]];
    imageView.image = image;
}


- (void)initActivityIndicator {
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_indicator];
    self.navigationItem.leftBarButtonItem = item;
    _indicator.hidesWhenStopped = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // create overlay
    _inputOverlay = [[UIView alloc] initWithFrame:self.view.bounds];
    _inputOverlay.backgroundColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:0.8f];
    
    //animation
    [UIView transitionWithView:self.view duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ { [self.view addSubview:_inputOverlay]; }
                    completion:nil];
    
    
    [self.view bringSubviewToFront:textField];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [_inputOverlay addGestureRecognizer:singleTap];
    
    self.currentResponder = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    _searchText = textField.text;
    
    if (_searchText) {
        [_inputOverlay removeFromSuperview];
        [textField resignFirstResponder];
        
        [self loadData:[NSString stringWithFormat:@"http://xun-wei.com/app/restaurants/?amount=30&keyword=%@",_searchText]];
        [textField setText:nil];// clear textfield after click search button
        return NO;
    } else {
        return YES;
    }
}

- (void)redirectToMapView {
    MapViewController *mapViewController = [[MapViewController alloc] init];
    // pass business detail info to vc
    [self.navigationController pushViewController:mapViewController animated:YES];
}

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
    [_inputOverlay removeFromSuperview];
}

- (void)redirectToDetailView:(UITapGestureRecognizer *)tap {
    NSInteger ID = tap.view.tag;
    
    DetailViewController *vc = [[DetailViewController alloc] initWithID:ID];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadData:(NSString *)text {
    [_indicator startAnimating];
    GetRestaurants *GR = [[GetRestaurants alloc] init];
    NSString *urlString = [NSString new];
    urlString = [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    __unused NSURLConnection *fetchConn = [[NSURLConnection alloc] initWithRequest:request
                                                                          delegate:GR
                                                                  startImmediately:YES];
    // 回调关键
    GR.delegate = self;
}

- (void)loadComplete {
    [_indicator stopAnimating];
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    _array = [userInfo objectForKey:@"restaurants"];
    
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