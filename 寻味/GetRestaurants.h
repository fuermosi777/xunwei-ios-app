//
//  GetRestaurants.h
//  寻味
//
//  Created by Hao Liu on 11/19/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeViewController.h"

@interface GetRestaurants : NSObject
{
    NSMutableData *incomingData;
}
@property (nonatomic, assign) HomeViewController *delegate; // 声明代理

@end
