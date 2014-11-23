//
//  DetailViewController.h
//  寻味
//
//  Created by Hao Liu on 11/20/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property NSMutableDictionary *dict;
@property MKMapView *mapView;
@property NSMutableArray *reviewArray;
@property UITableView *tableView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property MKCoordinateRegion region;

@end
