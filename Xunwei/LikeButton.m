//
//  LikeButton.m
//  Xunwei
//
//  Created by Hao Liu on 12/11/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#import "LikeButton.h"

@implementation LikeButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initButton];
    }
    return self;
}

- (void)initButton {
    //[self setBackgroundColor:[UIColor colorWithRed:0.93 green:0.35 blue:0.23 alpha:1]];
    [self.layer setCornerRadius:4.0f];
    [self.titleLabel setFont:[UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14]];
    
    // load data
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 1 start a post data
        NSString *post = [NSString stringWithFormat:@"username=%@&password=%@&restaurant_id=%@&action=GET",_username,_password,_restaurantID];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding
                              allowLossyConversion:YES];
        // 2 get data length
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        // 3 create url request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *url = [NSURL URLWithString:@"http://xun-wei.com/app/status/"];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSError *requestError;
        NSURLResponse *urlResponse = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
        
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error;
                NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:kNilOptions
                                                                              error:&error];
                NSInteger status = [[dict objectForKey:@"status"] integerValue];
                NSInteger isLiked = [[dict objectForKey:@"is_liked"] integerValue];
                
                if (status == 1) { // login success
                    if (isLiked == 1) {
                        [self setTitle:@"已收藏" forState:UIControlStateNormal];
                        [self setBackgroundColor:[UIColor colorWithRed:0.96 green:0.71 blue:0.65 alpha:1]];
                        [self setEnabled:NO];
                    } else {
                        [self setTitle:@"收藏" forState:UIControlStateNormal];
                        [self setBackgroundColor:[UIColor colorWithRed:0.93 green:0.35 blue:0.23 alpha:1]];
                        [self setEnabled:YES];
                    }
                    // add target
                    [self addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
                    
                } else { // unexplained error
                    
                }
            });
        } else {
            NSLog(@"error!");
        }
        
    });
}

- (void)clicked {
    // load data
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 1 start a post data
        NSString *post = [NSString stringWithFormat:@"username=%@&password=%@&restaurant_id=%@&action=POST",_username,_password,_restaurantID];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding
                              allowLossyConversion:YES];
        // 2 get data length
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        // 3 create url request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *url = [NSURL URLWithString:@"http://xun-wei.com/app/status/"];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSError *requestError;
        NSURLResponse *urlResponse = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
        
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error;
                NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:kNilOptions
                                                                              error:&error];
                NSInteger status = [[dict objectForKey:@"status"] integerValue];
                NSInteger isLiked = [[dict objectForKey:@"is_liked"] integerValue];
                
                if (status == 1) { // login success
                    if (isLiked == 1) {
                        [self setTitle:@"已收藏" forState:UIControlStateNormal];
                        [self setBackgroundColor:[UIColor colorWithRed:0.96 green:0.71 blue:0.65 alpha:1]];
                        [self setEnabled:NO];
                    } else {
                        [self setTitle:@"收藏" forState:UIControlStateNormal];
                        [self setBackgroundColor:[UIColor colorWithRed:0.93 green:0.35 blue:0.23 alpha:1]];
                        [self setEnabled:YES];
                    }
                } else { // unexplained error
                    
                }
            });
        } else {
            NSLog(@"error!");
        }
        
    });
}

@end
