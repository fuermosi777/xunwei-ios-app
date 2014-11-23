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
@property NSString *review;
@property NSInteger restaurantID;
@property NSInteger userID;
@property JSFavStarControl *control;
@property NSInteger star;
@property NSInteger price;
@property UILabel *starLabel;
@property UILabel *priceLabel;

- (void)receiveRating:(NSInteger)rating;

@end
