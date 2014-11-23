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
#import "GetRestaurants.h"

@interface MapViewController () <CLLocationManagerDelegate>

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // load data
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    _array = [userInfo objectForKey:@"restaurants"];
    
    [self showView];
}

- (void)showView {
    // map view
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _mapView.showsPointsOfInterest = NO;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    // location ma
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [_locationManager startUpdatingLocation]; // 开始更新当前位置信息
    [_locationManager setPausesLocationUpdatesAutomatically:YES]; // 允许自动停止更新位置信息
    
    // load markers
    if (_array) {
        [self loadMarkers];
    }
    
    // add button
    [self addFocusButton];
    
    // add navigationbar right button
    [self addRightButton];
}

- (void)addRightButton {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"在附近搜索"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(searchNearby)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)searchNearby {
    CLLocationCoordinate2D coord = _region.center;
    [self loadData:[NSString stringWithFormat:@"http://xun-wei.com/app/restaurants/?amount=30&lng=%f&lat=%f",coord.longitude,coord.latitude]];
}

- (void)loadData:(NSString *)text {
    GetRestaurants *GR = [[GetRestaurants alloc] init];
    NSString *urlString = [NSString new];
    urlString = [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    __unused NSURLConnection *fetchConn = [[NSURLConnection alloc] initWithRequest:request
                                                                          delegate:GR
                                                                  startImmediately:YES];
    // 回调关键
    GR.delegate2 = self;
}

- (void)loadComplete {
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    _array = [userInfo objectForKey:@"restaurants"];
    
    [self clearMarkers];
    [self loadMarkers];
}

// 收到当前位置更新的消息...
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    
    // first restaurant coor
    MarkerAnnotation *targetMarker = (MarkerAnnotation *)[_markers objectAtIndex:0];
    // 以点击的marker为中心居中地图
    CLLocationCoordinate2D targeCoord = {.latitude = targetMarker.coordinate.latitude, .longitude = targetMarker.coordinate.longitude};
    
    
    CLLocationCoordinate2D coord = {.latitude = currentLocation.coordinate.latitude, .longitude =  currentLocation.coordinate.longitude};
    MKCoordinateSpan span = {.latitudeDelta =  0.01, .longitudeDelta =  0.01};
    MKCoordinateRegion region = {coord, span};
    MKCoordinateRegion targetRegion = {targeCoord, span};
    _region = region;
    
    if (!_oneLocation) { // 获得唯一位置了
        [_mapView setRegion:targetRegion]; // 地图居中在first restaurant found
        _oneLocation = currentLocation;
    }
    
    [_mapView setShowsUserLocation:YES];
}

- (void)addFocusButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 74, 50, 50)];
    button.layer.cornerRadius = 20.0f;
    button.clipsToBounds = YES;
    [button setImage:[UIImage imageNamed:@"marker"] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:0.99 green:0.65 blue:0.18 alpha:0.9];
    [button addTarget:self action:@selector(focusMe) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)focusMe {
    [_mapView setRegion:_region animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 画markers 和 scroll
- (void)loadMarkers {
    // 新建卷动
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 5.0 / 6.0, self.view.frame.size.width, self.view.frame.size.height / 6.0)];
    _scrollView.delegate = self;
    [self.view insertSubview:_scrollView aboveSubview:_mapView];
    
    // 卷动开启翻页
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.alwaysBounceVertical = NO;
    
    // 重新设置卷动窗口宽度
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * [_array count], _scrollView.frame.size.height);
    
    _markers = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [_array count]; i++) {
        NSDictionary *dict = [_array objectAtIndex:i];
        // 添加marker
        NSString *latitudeString = [dict objectForKey:@"latitude"];
        double latitude = [latitudeString doubleValue];
        NSString *longitudeString = [dict objectForKey:@"longitude"];
        double longitude = [longitudeString doubleValue];
        
        CLLocationCoordinate2D coordinate = {.latitude = latitude, .longitude = longitude}; // 初始化marker
        MarkerAnnotation *marker = [[MarkerAnnotation alloc] initWithLocation:coordinate];
        
        marker.tag = i;
        
        [_mapView addAnnotation:marker];
        // 添加marker到model中
        [_markers addObject:marker];
        
        // 添加scroll image
        CGFloat xOrigin = i * self.view.frame.size.width;
        
        PanelViewOnMap *awesomeView = [[PanelViewOnMap alloc] initWithFrame:CGRectMake(xOrigin, 0, self.view.frame.size.width, _scrollView.frame.size.height)];
        
        [awesomeView setTitle:[dict objectForKey:@"name"]];
        
        NSString *tags = [[[dict objectForKey:@"subcategory"] valueForKey:@"description"] componentsJoinedByString:@", "];
        [awesomeView setTitle2:tags];
        
        [awesomeView setImage:[dict objectForKey:@"photo"]];
        
        [_scrollView addSubview:awesomeView];
        
        // set awesome view click
        UITapGestureRecognizer *awesomeViewSingleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                     action:@selector(redirectBusinessDetailView:)];
        [awesomeView addGestureRecognizer:awesomeViewSingleFingerTap];
        awesomeView.tag = [[dict objectForKey:@"id"] intValue];
        [awesomeView setUserInteractionEnabled:YES];
    }
}

- (void)redirectBusinessDetailView:(UITapGestureRecognizer *)tap {
    DetailViewController *vc = [[DetailViewController alloc] init];
    
    for (int i = 0; i < [_array count]; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        dict = [_array objectAtIndex:i];
        if ([[[_array objectAtIndex:i] objectForKey:@"id"] intValue] == tap.view.tag) {
            [vc setDict:dict];
            
        }
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

// 卷动了...
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    MarkerAnnotation *targetMarker = (MarkerAnnotation *)[_markers objectAtIndex:page];
    // 以点击的marker为中心居中地图
    CLLocationCoordinate2D coord = {.latitude = targetMarker.coordinate.latitude, .longitude = targetMarker.coordinate.longitude};
    [_mapView setCenterCoordinate:coord animated:YES]; // 地图居中在当前位置
}

// 点击marker
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)marker
{
    [_mapView deselectAnnotation:marker.annotation animated:YES];
    
    if ([marker.annotation isKindOfClass:[MarkerAnnotation class]]) {
        MarkerAnnotation *m = marker.annotation;
        
        // 以点击的marker为中心居中地图
        CLLocationCoordinate2D coord = {.latitude = marker.annotation.coordinate.latitude, .longitude = marker.annotation.coordinate.longitude};
        [_mapView setCenterCoordinate:coord animated:YES]; // 地图居中在当前位置
        // scroll 滚动到具体餐馆
        CGRect frame = _scrollView.frame;
        frame.origin.x = frame.size.width * m.tag;//滚动到制定餐馆
        frame.origin.y = 0;
        [_scrollView scrollRectToVisible:frame animated:YES];
    }
    
}

- (void)clearMarkers {
    if (_scrollView) {
        [_scrollView removeFromSuperview];
    }
    if (_markers) {
        [_mapView removeAnnotations:[_mapView annotations]];
    }
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
