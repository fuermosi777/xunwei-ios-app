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

@property UIScrollView *scrollView;
@property NSMutableArray *array; // all restaurants info
@property (nonatomic, assign) id currentResponder;
@property UIView *inputOverlay;
@property MKMapView *mapView;
@property NSString *searchText;

- (void)loadComplete;

@end
