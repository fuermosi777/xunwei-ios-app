//
//  NavigationViewController.m
//  寻味
//
//  Created by Hao Liu on 11/19/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:16], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"yellow"]
                             forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    
    // set bar button font
    self.navigationBar.titleTextAttributes = attributes;
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
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
