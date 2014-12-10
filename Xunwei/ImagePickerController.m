//
//  ImagePickerController.m
//  Xunwei
//
//  Created by Hao Liu on 12/9/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#import "ImagePickerController.h"

@implementation ImagePickerController

- (void)viewWillDisappear:(BOOL)animated {
    // status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (id)init {
    self = [super init];
    if (self) {
        [self initNavbar];
    }
    return self;
}

- (void)initNavbar {
    
    // bar bg color
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"yellow"]
                             forBarMetrics:UIBarMetricsDefault];
    // bar shadow
    [self.navigationBar setShadowImage:[UIImage new]];
    
    // title attr
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:16], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    // white color
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    // set bar button font
    self.navigationBar.titleTextAttributes = attributes;
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
}

@end
