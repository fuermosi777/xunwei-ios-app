//
//  ListItemView.m
//  寻味
//
//  Created by Hao Liu on 11/20/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#define SPACE 10

#import "ListItemView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ListItemView

- (id)initWithFrame:(CGRect)frame dataSource:(NSMutableDictionary *)dict {
    self = [super initWithFrame:frame];
    if (self) {
        // image
        CGFloat imageHeight = self.frame.size.height - SPACE * 2.0;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SPACE, SPACE, imageHeight, imageHeight)];
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 4.0;
        [self addSubview:imageView];
        
        // start a new image download manager
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSURL *photo_URL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"photo"]]];
        // start a new image download manager
        [manager downloadWithURL:photo_URL
                         options:0
                        progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            // NSLog(@"%li",(long)receivedSize);
                        }
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                           if (image) {
                               imageView.image = image;
                           }
                       }
         ];
        
        // title
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(imageHeight + SPACE * 3.0, SPACE, self.frame.size.width - imageHeight - SPACE * 3, 20)];
        title.textColor = [UIColor colorWithRed:0.9 green:0.56 blue:0.12 alpha:1];
        title.text = [dict objectForKey:@"name"];
        [self addSubview:title];
        
        // subtitle
        UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(imageHeight + SPACE * 3.0, SPACE + title.bounds.size.height, self.frame.size.width - imageHeight - SPACE * 3, 20)];
        subTitle.font = [UIFont systemFontOfSize:12];
        subTitle.textColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1];
        subTitle.text = [NSString stringWithFormat:@"%@ %@ %@",[dict objectForKey:@"street1"],[dict objectForKey:@"city"],[dict objectForKey:@"postcode"]];
        [self addSubview:subTitle];
        
        // layer
        CALayer *border = [CALayer layer];
        border.frame = CGRectMake(imageHeight + SPACE * 2.0, 0.0f, self.frame.size.width, .3f);
        border.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1].CGColor;
        [self.layer addSublayer:border];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
