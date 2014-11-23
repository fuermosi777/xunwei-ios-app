//
//  SingupTableViewController.h
//  Xunwei
//
//  Created by Hao Liu on 11/22/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingupTableViewController : UITableViewController <UITextFieldDelegate>
{
    NSMutableData *incomingData;
}
@property NSString *username;
@property NSString *email;
@property NSString *password;

@end
