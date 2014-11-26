//
//  HomeViewController.h
//  寻味
//
//  Created by Hao Liu on 11/19/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface HomeViewController : UIViewController < UITextFieldDelegate>

@property (strong, nonatomic) UIActivityIndicatorView *indicator;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *array; // all restaurants info
@property (nonatomic, assign) id currentResponder;
@property (strong, nonatomic) UIView *inputOverlay;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) NSString *searchText;
@property (strong, nonatomic) UIImageView *avatar;

- (void)loadComplete;
- (void)resetAvatar;

@end
