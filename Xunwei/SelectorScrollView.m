//
//  SelectorScrollView.m
//  Xunwei
//
//  Created by Hao Liu on 12/7/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#define BUTTONWIDTH 70

#import "SelectorScrollView.h"
#import "PointerView.h"

@implementation SelectorScrollView

- (id)initWithFrame:(CGRect)frame array:(NSMutableArray *)array {
    self = [super initWithFrame:frame];
    if (self) {
        _array = array;
        
        [self initView];
        [self initButtons];
        [self initPointer];

    }
    return self;
}

- (void)initView {
    [self setBackgroundColor: [UIColor colorWithRed:0.99 green:0.65 blue:0.25 alpha:1]];
    
    [self setContentSize:CGSizeMake(MAX(self.frame.size.width, BUTTONWIDTH * [_array count]), self.frame.size.height)];
    
    [self setShowsHorizontalScrollIndicator:NO];
}

- (void)initButtons {
    for (int i = 0; i < [_array count]; i++) {
        CGFloat xOrigin = BUTTONWIDTH * i;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(xOrigin, 0, BUTTONWIDTH, self.frame.size.height)];
        [button setTitle:[NSString stringWithFormat:@"%@", [_array objectAtIndex:i]] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14]];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [button setTag:i];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
    }
}

- (void)initPointer {
    _pointer = [[PointerView alloc] initWithFrame:CGRectMake(BUTTONWIDTH / 2.5, 30, 15, 10)];
    
    [self addSubview:_pointer];
}

- (void)buttonTapped:(UIButton *)button {
    // move pointer
    [UIView animateWithDuration:0.2
                     animations:^{
                         _pointer.frame = CGRectMake(button.tag * BUTTONWIDTH + BUTTONWIDTH / 2.5, 30, 15, 10);
                     }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectButtonTappedNotification"
                                                        object:button];
}

@end
