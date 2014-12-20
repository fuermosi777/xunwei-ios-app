//
//  SearchViewController.h
//  Xunwei
//
//  Created by Hao Liu on 12/19/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface SearchViewController : UIViewController <UITextFieldDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIView *navbar;
@property (strong, nonatomic) UITextField *searchField;
@property (strong, nonatomic) UITextField *cityField;
@property (retain, nonatomic) HomeViewController *delegate;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *array;

@end
