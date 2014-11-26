//
//  MapViewController.h
//  寻味
//
//  Created by Hao Liu on 11/20/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *array; // all restaurants info
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *oneLocation;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *markers;
@property MKCoordinateRegion region;

- (void)loadComplete;

@end
