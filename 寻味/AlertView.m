//
//  AlertView.m
//  寻味
//
//  Created by Hao Liu on 11/19/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView

- (void)showCustomErrorWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelText {
    self.title = title;
    self.message = message;
    self.cancelButtonIndex = [self addButtonWithTitle:cancelText];
    [self show];
}

@end
