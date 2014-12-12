//
//  AdScrollView.h
//  Xunwei
//
//  Created by Hao Liu on 12/11/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@class HomeViewController;


@interface AdScrollView : UIScrollView <UIScrollViewDelegate>

@property (strong, nonatomic) NSArray *array;
@property (weak, nonatomic) HomeViewController *parentVC;

@end
