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


@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self addRightButton];
    
    // navigationbar
    self.navigationController.navigationBar.topItem.title = @"发现";

}

- (void)reloadView {
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self loadData];
}

- (void)addRightButton {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"刷新"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(reloadView)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)showView {
    [self addScroll];
}

- (void)addScroll {
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_scrollView];
    _scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, [_array count] * LISTITEMHEIGHT);
    for (int i = 0; i < [_array count]; i++) {
        NSMutableDictionary *dict = [_array objectAtIndex:i];
        ListItemView *listItemView = [[ListItemView alloc] initWithFrame:CGRectMake(0, LISTITEMHEIGHT * i, self.view.frame.size.width, LISTITEMHEIGHT)
                                                              dataSource:dict];
        [_scrollView addSubview:listItemView];
    }
}

- (void)loadData {
    // 获取热门餐厅from URL
    GetRestaurants *GR = [[GetRestaurants alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://xun-wei.com/app/restaurants/?amount=20"];
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
