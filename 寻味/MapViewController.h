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

@property NSMutableArray *array; // all restaurants info
@property MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property CLLocation *oneLocation;
@property UIScrollView *scrollView;
@property NSMutableArray *markers;
@property MKCoordinateRegion region;

- (void)loadComplete;

@end
