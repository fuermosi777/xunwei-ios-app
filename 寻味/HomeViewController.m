//
//  HomeViewController.m
//  寻味
//
//  Created by Hao Liu on 11/19/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#define LISTITEMHEIGHT 80

#import "HomeViewController.h"
#import "GetRestaurants.h"
#import "ListItemView.h"
#import "DetailViewController.h"
#import <MapKit/MapKit.h>
#import "MapViewController.h"


@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData:nil];
    [self addRightButton];
    
    // navigationbar
    self.navigationController.navigationBar.topItem.title = @"寻味纽约";

}

- (void)reloadView {
    [self clearView];
    
    [self loadData:nil];
}

- (void)clearView {
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)addRightButton {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"] landscapeImagePhone:nil 
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(reloadView)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)showView {
    [self addMap];
    [self addScroll];
}

- (void)addMap {
    // 地图
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 100)];
    _mapView.showsPointsOfInterest = NO;
    // mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    
    // set region and zoom
    CLLocationCoordinate2D startCoord;
    startCoord.latitude = 40.714650000000f;
    startCoord.longitude = -73.997755000000;
    [_mapView setRegion:MKCoordinateRegionMakeWithDistance(startCoord, 200, 200) animated:YES];
    
    // add transparent overlay
    UIView *overlay = [[UIView alloc] initWithFrame:_mapView.bounds];
    [overlay setBackgroundColor:[UIColor colorWithRed:0.99 green:0.65 blue:0.18 alpha:0.5]];
    [_mapView addSubview:overlay];
    
    // add address label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, 40)];
    label.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    label.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
    label.text = @"在地图上查看";
    label.textAlignment = NSTextAlignmentCenter;
    
    [overlay addSubview:label];
    
    // add click event
    UITapGestureRecognizer *awesomeViewSingleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(redirectToMapView)];
    [label addGestureRecognizer:awesomeViewSingleFingerTap];
    [label setUserInteractionEnabled:YES];
    
    // add search box
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(30, 55 + 64, self.view.frame.size.width - 60, 30)];
    textField.backgroundColor = [UIColor whiteColor];
    textField.textColor = [UIColor grayColor];
    textField.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
    textField.layer.cornerRadius = 4.0f;
    textField.delegate = self;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"开始寻味"
                                                                      attributes:@{
                                                                                   NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                                                                   NSFontAttributeName : [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14.0],
                                                                                   }
     ];
    [self.view addSubview:textField];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // create overlay
    _inputOverlay = [[UIView alloc] initWithFrame:self.view.bounds];
    _inputOverlay.backgroundColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:0.8f];
    [self.view addSubview:_inputOverlay];
    [self.view bringSubviewToFront:textField];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [_inputOverlay addGestureRecognizer:singleTap];
    
    self.currentResponder = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    _searchText = textField.text;
    
    if (_searchText) {
        [_inputOverlay removeFromSuperview];
        [textField resignFirstResponder];

        [self clearView];
        [self loadData:_searchText];
        return NO;
    } else {
        return YES;
    }
}

- (void)redirectToMapView {
    MapViewController *mapViewController = [[MapViewController alloc] init];
    // pass business detail info to vc
    [self.navigationController pushViewController:mapViewController animated:YES];
}

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
    [_inputOverlay removeFromSuperview];
    
}

- (void)addScroll {
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 164, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 164, 0);
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, [_array count] * LISTITEMHEIGHT);
    _scrollView.showsVerticalScrollIndicator = NO;
    
    for (int i = 0; i < [_array count]; i++) {
        NSMutableDictionary *dict = [_array objectAtIndex:i];
        ListItemView *listItemView = [[ListItemView alloc] initWithFrame:CGRectMake(0, LISTITEMHEIGHT * i, self.view.frame.size.width, LISTITEMHEIGHT)
                                                              dataSource:dict];
        [_scrollView addSubview:listItemView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(redirectToDetailView:)];
        listItemView.tag = [[dict objectForKey:@"id"] intValue];
        
        [listItemView addGestureRecognizer:tap];
        [listItemView setUserInteractionEnabled:YES];
    }
}

- (void)redirectToDetailView:(UITapGestureRecognizer *)tap {
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

- (void)loadData:(NSString *)text {
    GetRestaurants *GR = [[GetRestaurants alloc] init];
    
    NSString *urlString = [NSString new];
    if (text) {
        urlString = [NSString stringWithFormat:@"http://xun-wei.com/app/restaurants/?amount=30&keyword=%@",text];
        
    } else {
        urlString = [NSString stringWithFormat:@"http://xun-wei.com/app/restaurants/?amount=30"];
    }
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    __unused NSURLConnection *fetchConn = [[NSURLConnection alloc] initWithRequest:request
                                                                          delegate:GR
                                                                  startImmediately:YES];
    // 回调关键
    GR.delegate = self;
}

- (void)loadComplete {
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    _array = [userInfo objectForKey:@"restaurants"];
    
    [self showView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
