//
//  SelectorScrollView.h
//  Xunwei
//
//  Created by Hao Liu on 12/7/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointerView.h"

@class PointerView;

@interface SelectorScrollView : UIScrollView

@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) PointerView *pointer;

- (id)initWithFrame:(CGRect)frame array:(NSMutableArray *)array;

@end
