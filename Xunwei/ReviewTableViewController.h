//
//  ReviewTableViewController.h
//  Xunwei
//
//  Created by Hao Liu on 11/22/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSFavStarControl.h"
@class JSFavStarControl;

@interface ReviewTableViewController : UITableViewController
{
    NSMutableData *incomingData;
}
@property (strong, nonatomic) NSString *review;
@property NSInteger restaurantID;
@property NSInteger userID;
@property (strong, nonatomic) JSFavStarControl *control;
@property NSInteger star;
@property NSInteger price;
@property (strong, nonatomic) UILabel *starLabel;
@property (strong, nonatomic) UILabel *priceLabel;

- (void)receiveRating:(NSInteger)rating;

@end
