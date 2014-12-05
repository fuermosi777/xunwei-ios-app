//
//  HomeViewController.h
//  寻味
//
//  Created by Hao Liu on 11/19/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface HomeViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIActivityIndicatorView *indicator;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *array; // all restaurants info
@property (nonatomic, assign) id currentResponder;
@property (strong, nonatomic) UIView *inputOverlay;
@property (strong, nonatomic) UIImageView *mapSnapshotView;

@property (strong, nonatomic) NSString *searchText;
@property (strong, nonatomic) UIImageView *avatar;
@property (strong, nonatomic) UIImage *avatarImage;

- (void)loadComplete;
- (void)resetAvatar;

@end
