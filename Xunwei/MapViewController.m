//
//  MapViewController.m
//  寻味
//
//  Created by Hao Liu on 11/20/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "MarkerAnnotation.h"
#import "PanelViewOnMap.h"
#import "DetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD/MBProgressHUD.h> // progress indicator
#import "AlertView.h"

@interface MapViewController () <CLLocationManagerDelegate>

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    
    [self showView];
}

- (void)loadData {
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    _array = [userInfo objectForKey:@"restaurants"];
}

- (void)showView {
    [self initMap];
    
    // load markers
    if (_array) {
        [self addMapAnnotations];
        [self centerMap];
    }
    
    // add button
    [self addFocusButton];
    
    
    
    // add navigationbar right button
    [self addRightButton];
}

- (void)initMap {
    _mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    _mapView.showsPointsOfInterest = NO;
    [self.view addSubview:_mapView];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [_locationManager startUpdatingLocation];
    
    // add layer
    [self addLayer];
}

- (void)searchNearby {
    CLLocationCoordinate2D coord = _mapView.region.center;
    [self loadData:[NSString stringWithFormat:@"http://xun-wei.com/app/restaurants/?amount=30&lng=%f&lat=%f&span=%f",coord.longitude,coord.latitude,_mapView.region.span.latitudeDelta]];
}

- (void)loadData:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // send url request
        NSString *urlString = [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlString];
        NSError *error;
        NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                
                NSError *error = nil;
                
                // 先输出array，然后第0位的才是dict
                NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:kNilOptions
                                                                          error:&error];
                
                // store to local
                NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
                [userInfo setValue:array forKey:@"restaurants"];
                [userInfo synchronize];
                
                // load complete
                [self loadComplete];
                
            });
        } else {
            [hud hide:YES];
            AlertView *alert = [[AlertView alloc] init];
            [alert showCustomErrorWithTitle:@"错误" message:@"请检查您的网络连接" cancelButton:@"好的"];
        }
        
    });
}

- (void)loadComplete {
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    _array = [userInfo objectForKey:@"restaurants"];
    
    [self clearMarkers];
    [self addMapAnnotations];
}


#pragma mark - add somthing
- (void)addFocusButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 74, 50, 50)];
    button.layer.cornerRadius = 20.0f;
    button.clipsToBounds = YES;
    [button setImage:[UIImage imageNamed:@"marker"] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:0.99 green:0.65 blue:0.18 alpha:0.9];
    [button addTarget:self action:@selector(focusMe) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)addLayer {
    int radius = self.view.frame.size.width / 2.0 - 20.0;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.mapView.bounds.size.width, self.mapView.bounds.size.height) cornerRadius:0];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(20, 64 + (self.view.frame.size.height - 64.0) / 2.0 - radius, 2.0*radius, 2.0*radius) cornerRadius:radius];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor colorWithRed:0.99 green:0.65 blue:0.25 alpha:0.4].CGColor;
    [self.view.layer addSublayer:fillLayer];
}

- (void)addRightButton {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"在当前区域搜索"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(searchNearby)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)centerMap {
    if ([_array count] != 0) {
        NSDictionary *dict = [_array objectAtIndex:0];
        CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake([[dict objectForKey:@"latitude"] floatValue], [[dict objectForKey:@"longitude"] floatValue]);
        
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 5000, 5000)];
        [_mapView setRegion:adjustedRegion animated:YES];
    }
}

- (void)focusMe {
    MKCoordinateRegion region;
    region.center = _mapView.userLocation.coordinate;
    region.span = _mapView.region.span;
    
    region = [_mapView regionThatFits:region];
    [_mapView setRegion:region animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addMapAnnotations {
    for (int i = 0; i < [_array count]; i++) {
        NSDictionary *dict = [_array objectAtIndex:i];
        
        NSString *latitudeString = [dict objectForKey:@"latitude"];
        double latitude = [latitudeString doubleValue];
        NSString *longitudeString = [dict objectForKey:@"longitude"];
        double longitude = [longitudeString doubleValue];
        
        CLLocationCoordinate2D coordinate = {.latitude = latitude, .longitude = longitude};
        
        MarkerAnnotation *marker = [[MarkerAnnotation alloc] initWithLocation:coordinate
                                                                        title:[NSString stringWithFormat:@"%@", [dict objectForKey:@"name"]]
                                                                     subTitle:[NSString stringWithFormat:@"%@ %@ %@", [dict objectForKey:@"street1"],[dict objectForKey:@"city"],[dict objectForKey:@"postcode"]]];
        [marker setTag:[[dict objectForKey:@"id"] intValue]];
        [marker setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [dict objectForKey:@"photo"]]]];
        
        [_mapView addAnnotation:marker];
    }
}

- (void)redirectToDetailView:(UITapGestureRecognizer *)tap {
    DetailViewController *vc = [[DetailViewController alloc] initWithID:tap.view.tag];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Marker"];
    
    if ([annotation isKindOfClass:[MarkerAnnotation class]]) {

        annotationView.image = [UIImage imageNamed:@"mapannotation"];
        
        //annotationView.animatesDrop = YES;
        
        annotationView.canShowCallout = NO;
        
    } else {
        annotationView.canShowCallout = NO;
        annotationView = nil;
    }
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[MarkerAnnotation class]]) {
        // remove callout
        if (_callout){
            [UIView animateWithDuration:0.1
                             animations:^{
                                 _callout.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 100);
                             }];
            // center annotation
            MKCoordinateRegion region;
            region.center = [(MarkerAnnotation *)view.annotation coordinate];
            region.span = _mapView.region.span;
            [_mapView setRegion:region animated:YES];
            
        }
        
        
        // add callout
        _callout = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 100)];
        [_callout setBackgroundColor:[UIColor colorWithRed:0.61 green:0.71 blue:0.02 alpha:0.8]];
        
        UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 70, 70)];
        [avatarView sd_setImageWithURL:[(MarkerAnnotation *)view.annotation imageURL]];
        [avatarView setClipsToBounds:YES];
        [avatarView setContentMode:UIViewContentModeScaleAspectFill];
        [avatarView.layer setCornerRadius:14.0];
        [_callout addSubview:avatarView];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, self.view.frame.size.width - 100 - 15, 20)];
        [title setText:[NSString stringWithFormat:@"%@",[(MarkerAnnotation *)view.annotation title]]];
        [title setFont:[UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:16]];
        [title setTextColor:[UIColor whiteColor]];
        [_callout addSubview:title];
        
        UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(100, 35, self.view.frame.size.width - 100 - 15, 20)];
        [subTitle setText:[NSString stringWithFormat:@"%@",[(MarkerAnnotation *)view.annotation subtitle]]];
        [subTitle setFont:[UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:12]];
        [subTitle setTextColor:[UIColor whiteColor]];
        [_callout addSubview:subTitle];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(redirectToDetailView:)];
        
        [_callout addGestureRecognizer:tap];
        _callout.tag = [(MarkerAnnotation *)view.annotation tag];
        [_callout setUserInteractionEnabled:YES];
        
        // animation add subview
        [self.view addSubview:_callout];
        _callout.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 64);
        [UIView animateWithDuration:0.1
                         animations:^{
                             _callout.frame = CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 100);
                         }];
        
    }
}

- (void)clearMarkers {
    [_mapView removeAnnotations:[_mapView annotations]];
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
