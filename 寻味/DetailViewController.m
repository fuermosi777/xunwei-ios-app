//
//  DetailViewController.m
//  寻味
//
//  Created by Hao Liu on 11/20/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//
#define MULTIPLIER 1.8
#define SECTIONNUM 3

#define IMAGESECTION 0
#define INFOSECTION 1
#define REVIEWSECTION 2

#define TITLE 0
#define IMAGE 1
#define ACTION 2

#define ADDRESS 0
#define PHONE 1
#define WEBSITE 2
#define PRICE 3
#define SUBCATEGORY 4
#define DESCRIPTION 5

#import "DetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //bg
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    [self showView];
}

- (void)showView {
    [self addTable];
}

- (void)addTable {
    // load
    _reviewArray = [_dict objectForKey:@"review"];
    
    //self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -40, self.view.frame.size.width, self.view.frame.size.height + 40)
                                              style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.96 alpha:1];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// section title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionName;
    switch (section)
    {
        case IMAGESECTION:
            break;
        case INFOSECTION:
            sectionName = @"详细信息";
            break;
        case REVIEWSECTION:
            sectionName = @"最新评论";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SECTIONNUM;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNum;
    switch (section) {
        case IMAGESECTION:
        {
            rowNum = 3;
            break;
        }
        case INFOSECTION:
        {
            rowNum = 5;
            break;
        }
        case REVIEWSECTION:
        {
            rowNum = [_reviewArray count];
            break;
        }
        default:
            break;
    }
    return rowNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger rowHeight;
    switch (indexPath.section) {
        case IMAGESECTION:
        {
            switch (indexPath.row) {
                case TITLE:
                {
                    rowHeight = 70;
                    break;
                }
                case ACTION:
                {
                    rowHeight = 70;
                    break;
                }
                case IMAGE:
                {
                    rowHeight = self.view.frame.size.width * 3.0 / 4.0;
                    break;
                }
                default:
                {
                    rowHeight = 40;
                    break;
                }
            }
            
            break;
        }
        case INFOSECTION:
        {
            switch (indexPath.row) {
                case DESCRIPTION:
                {
                    // get height
                    CGSize maximumLabelSize = CGSizeMake(self.view.frame.size.width, FLT_MAX);
                    CGSize expectedLabelSize = [[_dict objectForKey:@"description"] sizeWithFont:[UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14]
                                                                               constrainedToSize:maximumLabelSize
                                                                                   lineBreakMode:NSLineBreakByWordWrapping];
                    
                    //adjust the label the the new height.
                    rowHeight = expectedLabelSize.height * MULTIPLIER;
                    break;
                }
                default:
                {
                    rowHeight = 40;
                    break;
                }
            }

            break;
        }
        case REVIEWSECTION:
        {
            NSMutableDictionary *reviewDict = [_reviewArray objectAtIndex:indexPath.row];
            // get height
            CGSize maximumLabelSize = CGSizeMake(self.view.frame.size.width, FLT_MAX);
            CGSize expectedLabelSize = [[reviewDict objectForKey:@"review"] sizeWithFont:[UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14]
                                                                       constrainedToSize:maximumLabelSize
                                                                           lineBreakMode:NSLineBreakByWordWrapping];
            
            //adjust the label the the new height.
            rowHeight = expectedLabelSize.height * MULTIPLIER;
            break;
        }
        default:
            break;
    }
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *myCellView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                         reuseIdentifier:@"Cell"];
    switch (indexPath.section) {
        case IMAGESECTION:
        {
            switch (indexPath.row) {
                case TITLE:
                {
                    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 30)];
                    title.textColor = [UIColor colorWithRed:0.9 green:0.56 blue:0.12 alpha:1];
                    title.text = [_dict objectForKey:@"name"];
                    title.textAlignment = NSTextAlignmentCenter;
                    
                    [myCellView addSubview:title];
                    
                    UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, self.view.frame.size.width, 20)];
                    subTitle.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:12];
                    subTitle.textColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1];
                    subTitle.text = [NSString stringWithFormat:@"%@ %@ %@",[_dict objectForKey:@"street1"],[_dict objectForKey:@"city"],[_dict objectForKey:@"postcode"]];
                    [myCellView addSubview:subTitle];
                    subTitle.textAlignment = NSTextAlignmentCenter;
                    
                    break;
                }
                case IMAGE:
                {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20.0, self.view.frame.size.width * 3.0 / 4.0)];
                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                    imageView.clipsToBounds = YES;
                    imageView.layer.cornerRadius = 4.0;
                    
                    // start a new image download manager
                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
                    NSURL *photo_URL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",[_dict objectForKey:@"photo"]]];
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
                    [myCellView addSubview:imageView];
                    break;
                }
                case ACTION:
                {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width , 70)];
                    label.textColor = [UIColor colorWithRed:0.9 green:0.56 blue:0.12 alpha:1];
                    label.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:16];
                    label.text = [NSString stringWithFormat:@"%@",[_dict objectForKey:@"star"]];
                    
                    [myCellView addSubview:label];
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
        case INFOSECTION:
        {
            switch (indexPath.row) {
                case ADDRESS:
                {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width , 40)];
                    label.textColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1];
                    label.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
                    label.text = [NSString stringWithFormat:@"地址: %@ %@ %@",[_dict objectForKey:@"street1"],[_dict objectForKey:@"city"],[_dict objectForKey:@"postcode"]];
                    
                    [myCellView addSubview:label];
                    break;
                }
                case PHONE:
                {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width , 40)];
                    label.textColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1];
                    label.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
                    label.text = [NSString stringWithFormat:@"电话: %@",[_dict objectForKey:@"phone"]];
                    
                    [myCellView addSubview:label];
                    break;
                }
                case WEBSITE:
                {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width , 40)];
                    label.textColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1];
                    label.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
                    label.text = [NSString stringWithFormat:@"网站: %@",[_dict objectForKey:@"website"]];
                    
                    [myCellView addSubview:label];
                    break;
                }
                case PRICE:
                {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width , 40)];
                    label.textColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1];
                    label.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
                    label.text = [NSString stringWithFormat:@"人均: %@",[_dict objectForKey:@"price"]];
                    
                    [myCellView addSubview:label];
                    break;
                }
                case SUBCATEGORY:
                {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width , 40)];
                    label.textColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1];
                    label.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
                    NSString *subcategorys = [[[_dict objectForKey:@"subcategory"] valueForKey:@"description"] componentsJoinedByString:@", "];
                    
                    label.text = subcategorys;
                    
                    [myCellView addSubview:label];
                    break;
                }
                case DESCRIPTION:
                {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20 , myCellView.contentView.frame.size.height)];
                    label.textColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1];
                    label.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
                    
                    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
                    style.minimumLineHeight = 20.f;
                    style.maximumLineHeight = 20.f;
                    NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,};
                    label.attributedText = [[NSAttributedString alloc] initWithString:[_dict objectForKey:@"description"]
                                                                           attributes:attributtes];
                    
                    label.numberOfLines = 0;
                    label.lineBreakMode = NSLineBreakByWordWrapping;
                    [label sizeToFit];
                    
                    [myCellView addSubview:label];
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
        case REVIEWSECTION:
        {
            NSMutableDictionary *reviewDict = [_reviewArray objectAtIndex:indexPath.row];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20 , myCellView.contentView.frame.size.height)];
            label.textColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1];
            label.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];

            
            NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
            style.minimumLineHeight = 20.f;
            style.maximumLineHeight = 20.f;
            NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,};
            label.attributedText = [[NSAttributedString alloc] initWithString:[reviewDict objectForKey:@"review"]
                                                                   attributes:attributtes];
            
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            [label sizeToFit];
            
            [myCellView addSubview:label];
        }
        default:
            break;
    }

    myCellView.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return myCellView;
}

@end
