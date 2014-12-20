//
//  HomeViewController.h
//  寻味
//
//  Created by Hao Liu on 11/19/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SelectorScrollView.h"
#import "AdScrollView.h"
#import <MBProgressHUD/MBProgressHUD.h> // progress indicator

@class SelectorScrollView;
@class AdScrollView;

@interface HomeViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *array; // all restaurants info
@property (strong, nonatomic) SelectorScrollView *navScrollView;
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (strong, nonatomic) UIImageView *mapSnapshotView;
@property (strong, nonatomic) AdScrollView *adScrollView;

@property (strong, nonatomic) NSString *searchText;
@property (strong, nonatomic) UIImageView *avatar;
@property (strong, nonatomic) UIImage *avatarImage;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) MBProgressHUD *hud;

@property (strong, nonatomic) UITextField *textField;

- (void)loadData:(NSString *)text;
- (void)loadComplete;
- (void)resetAvatar;

@end
