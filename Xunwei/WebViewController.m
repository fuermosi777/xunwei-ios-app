//
//  WebViewController.m
//  Xunwei
//
//  Created by Hao Liu on 12/11/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (id)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        _url = url;
        [self.view setBackgroundColor:[UIColor whiteColor]];
        [self initWebView];
    }
    return self;
}

- (void)initWebView {
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    
    [_webView setDelegate:self];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:_url]];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // starting the load, show the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // load error, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // report the error inside the webview
    NSString* errorString = [NSString stringWithFormat:
                             @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
                             error.localizedDescription];
    [_webView loadHTMLString:errorString baseURL:nil];
}


@end
