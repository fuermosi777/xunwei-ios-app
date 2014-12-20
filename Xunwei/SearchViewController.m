//
//  SearchViewController.m
//  Xunwei
//
//  Created by Hao Liu on 12/19/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//
#define MAXHISTORY 15
#import "SearchViewController.h"
#import "AlertView.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [_searchField becomeFirstResponder];
    [self initArray];
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self locateSelf];
    [self addNavbar];
    [self addRightButton];
    [self addSearchField];
    [self addCityField];
    [self addTableView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
}

- (void)initArray {
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    _array = [userInfo objectForKey:@"searchHistory"];
}

- (void)addNavbar {
    _navbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 104)];
    [_navbar setBackgroundColor:[UIColor colorWithRed:1 green:0.65 blue:0.24 alpha:1]];
    [self.view addSubview:_navbar];
}

- (void)addRightButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60, 29, 50, 20)];
    [button addTarget:self action:@selector(redirectBack) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:16]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_navbar addSubview:button];
}

- (void)addSearchField {
    // add search box
    _searchField = [[UITextField alloc] initWithFrame:CGRectMake(10, 29, self.view.frame.size.width * 3/4, 26)];
    _searchField.backgroundColor = [UIColor whiteColor];
    _searchField.textColor = [UIColor grayColor];
    _searchField.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
    _searchField.layer.cornerRadius = 13.0f;
    _searchField.delegate = self;
    _searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"开始寻味"
                                                                      attributes:@{
                                                                                   NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                                                                   NSFontAttributeName : [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14.0],
                                                                                   }
                                       ];
    // add search icon
    UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(7, 5, 15, 15)];
    [searchIcon setImage:[UIImage imageNamed:@"search"]];
    [_searchField addSubview:searchIcon];
    
    // set padding
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
    _searchField.leftView = paddingView;
    _searchField.leftViewMode = UITextFieldViewModeAlways;
    
    [_navbar addSubview:_searchField];
    
    [_searchField setReturnKeyType:UIReturnKeySearch];
}

- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, self.view.frame.size.width, self.view.frame.size.height - 104)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)addCityField {
    // add search box
    _cityField = [[UITextField alloc] initWithFrame:CGRectMake(10, 64, self.view.frame.size.width * 3/4, 26)];
    _cityField.backgroundColor = [UIColor whiteColor];
    _cityField.textColor = [UIColor grayColor];
    _cityField.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
    _cityField.layer.cornerRadius = 13.0f;
    _cityField.delegate = self;
    _cityField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"城市 (New York)"
                                                                         attributes:@{
                                                                                      NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                                                                      NSFontAttributeName : [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14.0],
                                                                                      }
                                          ];
    // add search icon
    UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(7, 5, 15, 15)];
    [searchIcon setImage:[UIImage imageNamed:@"marker15"]];
    [_cityField addSubview:searchIcon];
    
    // set value
    [_cityField setText:@"当前位置"];
    
    // set padding
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
    _cityField.leftView = paddingView;
    _cityField.leftViewMode = UITextFieldViewModeAlways;
    
    [_cityField setReturnKeyType:UIReturnKeySearch];
    
    [_navbar addSubview:_cityField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *keyword = _searchField.text;
    NSString *city = _cityField.text;
    if ([city isEqualToString:@"当前位置"]) {
        [_delegate loadData:[NSString stringWithFormat:@"http://xun-wei.com/app/restaurants/?amount=50&keyword=%@&lat=%f&lng=%f&span=0.05",keyword,_currentLocation.coordinate.latitude,_currentLocation.coordinate.longitude]];
    } else {
        [_delegate loadData:[NSString stringWithFormat:@"http://xun-wei.com/app/restaurants/?amount=50&city=%@&keyword=%@",city,keyword]];
    }
    // store keyword
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSMutableArray *historyArray = [[NSMutableArray alloc] init];
    // first time
    if (![userInfo objectForKey:@"searchHistory"]) {
        [historyArray addObject:keyword];
        [userInfo setObject:historyArray forKey:@"searchHistory"];
        [userInfo synchronize];
    } else { // not first time
        [historyArray addObjectsFromArray:[userInfo objectForKey:@"searchHistory"]];
        if ([historyArray indexOfObject:keyword] == NSNotFound) {
            if ([historyArray count] == MAXHISTORY) {
                [historyArray removeObjectAtIndex:0];
            }
            [historyArray addObject:keyword];
            [userInfo setObject:historyArray forKey:@"searchHistory"];
            [userInfo synchronize];
        } else {
        }
    }
    
    [self redirectBack];
    return YES;
}

- (void)redirectBack {
    [self dismissViewControllerAnimated:YES completion:^{}];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *text = [NSString stringWithFormat:@"%@", [[[_array reverseObjectEnumerator] allObjects] objectAtIndex:indexPath.row]];
    [cell.textLabel setText:text];
    [cell.textLabel setFont:[UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    _searchField.text = cell.textLabel.text;
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
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    AlertView *alert = [[AlertView alloc] init];
    [alert showCustomErrorWithTitle:@"错误" message:@"无法定位您的位置，请确保寻味的定位许可已经开启" cancelButton:@"好的"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
