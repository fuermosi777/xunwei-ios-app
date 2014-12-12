//
//  RestaurantListTableViewController.h
//  Xunwei
//
//  Created by Hao Liu on 12/11/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantListTableViewController : UITableViewController

@property (strong,nonatomic) NSArray *array;

- (id)initWithArray:(NSArray *)array;

@end
