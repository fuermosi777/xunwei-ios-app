//
//  AlertView.h
//  寻味
//
//  Created by Hao Liu on 11/19/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertView : UIAlertView
- (void)showCustomErrorWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelText;
@end
