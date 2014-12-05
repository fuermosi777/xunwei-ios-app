//
//  UserTableViewController.h
//  Xunwei
//
//  Created by Hao Liu on 11/21/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewController : UITableViewController
{
    NSMutableData *incomingData;
}
@property (strong, nonatomic) NSDictionary *dict;
@end
