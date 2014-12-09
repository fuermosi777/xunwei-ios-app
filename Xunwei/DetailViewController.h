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

@property (strong, nonatomic) NSMutableDictionary *dict;
@property NSInteger ID;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) NSMutableArray *reviewArray;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImage *image; // restaurant image


- (id)initWithID:(NSInteger) ID;

@end
