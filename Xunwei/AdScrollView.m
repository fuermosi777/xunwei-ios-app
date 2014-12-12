//
//  AdScrollView.m
//  Xunwei
//
//  Created by Hao Liu on 12/11/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#import "AdScrollView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "WebViewController.h"

@implementation AdScrollView

int x = 0;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadData];
        [self setDelegate:self];
    }
    return self;
}

- (void)loadData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // send url request
        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://xun-wei.com/app/ad/"]];
        NSError *error;
        NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error;
                _array = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
                [self addAd];
            });
        } else {
            NSLog(@"error!");
        }
        
    });
}

- (void)addAd {
    NSInteger numOfAds = [_array count];
    [self setContentSize:CGSizeMake(self.frame.size.width * numOfAds, self.frame.size.height)];
    [self setShowsHorizontalScrollIndicator:NO];
    [self setPagingEnabled:YES];
    
    for (int i = 0; i < numOfAds; i++) {
        NSDictionary *dict = [_array objectAtIndex:i];
        UIImageView *ad = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        [ad sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@", [dict objectForKey:@"photo"] ] ]];

        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(openAd:)];
        [ad setTag:i];
        [ad addGestureRecognizer:gesture];
        [ad setUserInteractionEnabled:YES];
        [ad setClipsToBounds:YES];
        [ad setContentMode:UIViewContentModeScaleAspectFill];
        
        [self addSubview:ad];
    }
    
    // start auto scroll
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(scroll)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)openAd:(UITapGestureRecognizer *)gesture {
    NSDictionary *dict = [_array objectAtIndex:gesture.view.tag];
    
    WebViewController *vc = [[WebViewController alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [dict objectForKey:@"link"]]]];
    
    [_parentVC.navigationController pushViewController:vc animated:YES];
}

- (void)scroll {
    
    // Updates the variable h, adding 100 (put your own value here!)
    x += self.frame.size.width;
    
    if (x >= self.frame.size.width * [_array count]) {
        [self setContentOffset:CGPointMake(0, 0) animated:YES];
        x = 0;
    } else {
        [self setContentOffset:CGPointMake(x, 0) animated:YES];
    }
    
}

@end
