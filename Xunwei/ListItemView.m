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
#import "JSFavStarControl.h"

@implementation ListItemView

- (id)initWithFrame:(CGRect)frame dataSource:(NSMutableDictionary *)dict {
    self = [super initWithFrame:frame];
    if (self) {
        // image
        CGFloat imageHeight = self.frame.size.height - SPACE * 2.0;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SPACE, SPACE, imageHeight, imageHeight)];
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 14.0;
        [self addSubview:imageView];
        
        // start a new image download manager
        NSURL *photo_URL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"photo"]]];
        [imageView sd_setImageWithURL:photo_URL];
        
        // title
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(imageHeight + SPACE * 3.0, SPACE, self.frame.size.width - imageHeight - SPACE * 3, 20)];
        title.textColor = [UIColor colorWithRed:0.9 green:0.56 blue:0.12 alpha:1];
        title.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:16];
        title.text = [dict objectForKey:@"name"];
        [self addSubview:title];
        
        // subtitle
        UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(imageHeight + SPACE * 3.0, SPACE + title.bounds.size.height, self.frame.size.width - imageHeight - SPACE * 3, 20)];
        subTitle.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:12];
        subTitle.textColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1];
        subTitle.text = [NSString stringWithFormat:@"%@ %@ %@",[dict objectForKey:@"street1"],[dict objectForKey:@"city"],[dict objectForKey:@"postcode"]];
        [self addSubview:subTitle];
        
        // star
        UILabel *starlabel = [[UILabel alloc] initWithFrame:CGRectMake(imageHeight + SPACE * 3.0, SPACE + title.bounds.size.height + subTitle.bounds.size.height, self.frame.size.width - imageHeight - SPACE * 3, 20)];
        starlabel.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
        starlabel.textColor = [UIColor colorWithRed:0.61 green:0.71 blue:0.02 alpha:1];
        starlabel.text = [NSString stringWithFormat:@"🔥 %@",[dict objectForKey:@"star"]];
        [self addSubview:starlabel];
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
