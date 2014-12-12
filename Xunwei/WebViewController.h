//
//  WebViewController.h
//  Xunwei
//
//  Created by Hao Liu on 12/11/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) UIWebView *webView;

- (id)initWithURL:(NSURL *)url;


@end
