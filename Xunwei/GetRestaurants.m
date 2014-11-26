//
//  GetRestaurants.m
//  寻味
//
//  Created by Hao Liu on 11/19/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#import "GetRestaurants.h"
#import "AlertView.h"

@implementation GetRestaurants

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!incomingData) {
        incomingData = [[NSMutableData alloc] init];
    }
    
    [incomingData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    AlertView *alertView = [[AlertView alloc] init];
    [alertView showCustomErrorWithTitle:@"错误" message:@"请检查网络连接" cancelButton:@"确定"];
}

// 数据全部接受完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    
    // 先输出array，然后第0位的才是dict
    NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:incomingData
                                                            options:kNilOptions
                                                              error:&error];
    
    // store to local
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    [userInfo setValue:array forKey:@"restaurants"];
    [userInfo synchronize];
    
    // send complete signal
    [_delegate loadComplete];
    [_delegate2 loadComplete];
    
}
@end
