//
//  PointerView.m
//  Xunwei
//
//  Created by Hao Liu on 12/7/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#import "PointerView.h"

@implementation PointerView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.opaque = NO;
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(ctx,rect);
    
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint   (ctx, CGRectGetMidX(rect), CGRectGetMinY(rect));  // top left
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect));  // mid right
    CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));  // bottom left
    CGContextClosePath(ctx);
    
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
    CGContextFillPath(ctx);

}

@end
