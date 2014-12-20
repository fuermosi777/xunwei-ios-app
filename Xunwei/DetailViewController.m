
#define MULTIPLIER 1
#define SECTIONNUM 4

#define IMAGESECTION 0
#define INFOSECTION 1
#define REVIEWSECTION 2
#define MAPSECTION 3

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
#import <MapKit/MapKit.h>
#import "MarkerAnnotation.h"
#import "SigninTableViewController.h"
#import "ReviewTableViewController.h"
#import "UMSocial.h"
#import "UserTableViewController.h"
#import "LikeButton.h"
#import <MBProgressHUD/MBProgressHUD.h> // progress indicator

@interface DetailViewController () <CLLocationManagerDelegate, UMSocialUIDelegate>

@end

@implementation DetailViewController

- (id)initWithID:(NSInteger) ID {
    self = [super init];
    if (self) {
        _ID = ID;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //bg
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    [self showView];
}

- (void)loadData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // send url request
        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://xun-wei.com/app/restaurants/?restaurant_id=%li",(long)_ID]];
        NSError *error;
        NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
        if (data != nil) {
            [hud setHidden:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error;
                NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:kNilOptions
                                                                          error:&error];
                // load data
                _dict = [array objectAtIndex:0];
                _reviewArray = [_dict objectForKey:@"review"];
                
                [_tableView reloadData];
                
            });
        } else {
            [hud setHidden:YES];
            NSLog(@"error!");
        }
        
    });
}

- (void)showView {
    [self addTable];
    [self addRightButton];
}

- (void)addRightButton {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"分享"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(share)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)share {
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"54812a4bfd98c5c974000ed6"
                                      shareText:[NSString stringWithFormat:@"%@\n%@", [_dict objectForKey:@"name"], [_dict objectForKey:@"street1"]]
                                     shareImage:_image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatFavorite,UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                       delegate:self];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"http://xun-wei.com/app/webpage/restaurant/%@/",[_dict objectForKey:@"id"]];
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"http://xun-wei.com/app/webpage/restaurant/%@/",[_dict objectForKey:@"id"]];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"分享了一个餐馆";
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"分享了一个餐馆";
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

- (BOOL)isDirectShareInIconActionSheet {
    return YES;
}

- (void)addTable {
    
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
        case MAPSECTION:
            sectionName = @"地图";
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
            rowNum = 6;
            break;
        }
        case REVIEWSECTION:
        {
            rowNum = [_reviewArray count];
            break;
        }
        case MAPSECTION:
        {
            rowNum = 1;
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
                    CGSize maximumLabelSize = CGSizeMake(self.view.frame.size.width - 30, MAXFLOAT);
                    
                    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
                    style.minimumLineHeight = 20.f;
                    style.maximumLineHeight = 20.f;
                    
                    NSDictionary *attributes = @{
                                                 NSFontAttributeName: [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14],
                                                 NSParagraphStyleAttributeName : style
                                                 };
                    
                    CGRect expectedLabelSize = [[_dict objectForKey:@"description"] boundingRectWithSize:maximumLabelSize
                                                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                                                              attributes:attributes
                                                                                                 context:nil];
                    
                    //adjust the label the the new height.
                    rowHeight = expectedLabelSize.size.height * MULTIPLIER + 26;
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
            CGSize maximumLabelSize = CGSizeMake(self.view.frame.size.width - 15 - 40 - 15, MAXFLOAT);
            
            NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
            style.minimumLineHeight = 20.f;
            style.maximumLineHeight = 20.f;

            NSDictionary *attributes = @{
                                         NSFontAttributeName: [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14],
                                         NSParagraphStyleAttributeName : style
                                         };
            
            CGRect expectedLabelSize = [[reviewDict objectForKey:@"review"] boundingRectWithSize:maximumLabelSize
                                                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                                                      attributes:attributes
                                                                                         context:nil];
            
            //adjust the label the the new height.
            rowHeight = expectedLabelSize.size.height * MULTIPLIER + 26 + 25;
            break;
        }
        case MAPSECTION:
        {
            rowHeight = 200;
            break;
        }
        default:
            break;
    }
    return rowHeight;
}

// 分段标题设置字体颜色等
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(15, 15, self.view.frame.size.width, 20);
    myLabel.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
    myLabel.textColor = [UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *myCellView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                         reuseIdentifier:@"Cell"];
    if (_dict) {
        switch (indexPath.section) {
            case IMAGESECTION:
            {
                switch (indexPath.row) {
                    case TITLE:
                    {
                        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 30)];
                        title.textColor = [UIColor colorWithRed:0.9 green:0.56 blue:0.12 alpha:1];
                        title.text = [_dict objectForKey:@"name"];
                        title.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:16];
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
                        NSURL *photo_URL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",[_dict objectForKey:@"photo"]]];
                        [imageView sd_setImageWithURL:photo_URL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            _image = image;
                        }];
                        
                        [myCellView addSubview:imageView];
                        break;
                    }
                    case ACTION:
                    {
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width , 70)];
                        label.textColor = [UIColor colorWithRed:0.9 green:0.56 blue:0.12 alpha:1];
                        label.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:16];
                        label.text = [NSString stringWithFormat:@"%@",[_dict objectForKey:@"star"]];
                        
                        // like button
                        if (self.checkLoginStatus){
                            LikeButton *likeButton = [[LikeButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 110 - 10 - 100, 15, 100, 40)];
                            NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
                            NSString *username = [userInfo objectForKey:@"username"];
                            NSString *password = [userInfo objectForKey:@"password"];
                            NSString *restaurantID = [_dict objectForKey:@"id"];
                            [likeButton setUsername:username];
                            [likeButton setPassword:password];
                            [likeButton setRestaurantID:restaurantID];
                            
                            [myCellView addSubview:likeButton];
                        } else {
                            UIButton *likeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 110 - 10 - 100, 15, 100, 40)];
                            [likeButton setTitle:@"收藏" forState:UIControlStateNormal];
                            [likeButton setBackgroundColor:[UIColor colorWithRed:0.93 green:0.35 blue:0.23 alpha:1]];
                            [likeButton.titleLabel setFont:[UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14]];
                            [likeButton.layer setCornerRadius:4.0];
                            [likeButton addTarget:self action:@selector(redirectToSigninView) forControlEvents:UIControlEventTouchUpInside];
                            [myCellView addSubview:likeButton];
                        }
                        
                        // review button
                        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 110, 15, 100, 40)];
                        [button setBackgroundColor:[UIColor colorWithRed:0.63 green:0.75 blue:0.16 alpha:1]];
                        [button setTitle:@"写评价" forState:UIControlStateNormal];
                        [button.titleLabel setFont:[UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14]];
                        [button.layer setCornerRadius:4.0];
                        [button addTarget:self action:@selector(chooseUserOrSignin) forControlEvents:UIControlEventTouchUpInside];
                        
                        [myCellView addSubview:button];
                        
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
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 14, 14)];
                        imageView.image = [UIImage imageNamed:@"marker14"];
                        [myCellView addSubview: imageView];
                        
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, self.view.frame.size.width , 40)];
                        label.textColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1];
                        label.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
                        label.text = [NSString stringWithFormat:@"%@ %@ %@",[_dict objectForKey:@"street1"],[_dict objectForKey:@"city"],[_dict objectForKey:@"postcode"]];
                        
                        [myCellView addSubview:label];
                        break;
                    }
                    case PHONE:
                    {
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 14, 14)];
                        imageView.image = [UIImage imageNamed:@"phone14"];
                        [myCellView addSubview: imageView];
                        
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, self.view.frame.size.width , 40)];
                        label.textColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1];
                        label.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
                        label.text = [NSString stringWithFormat:@"电话: %@",[_dict objectForKey:@"phone"]];
                        
                        [myCellView addSubview:label];
                        break;
                    }
                    case WEBSITE:
                    {
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 14, 14)];
                        imageView.image = [UIImage imageNamed:@"computer14"];
                        [myCellView addSubview: imageView];
                        
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, self.view.frame.size.width , 40)];
                        label.textColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1];
                        label.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
                        label.text = [NSString stringWithFormat:@"网站: %@",[_dict objectForKey:@"website"]];
                        
                        [myCellView addSubview:label];
                        break;
                    }
                    case PRICE:
                    {
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 14, 14)];
                        imageView.image = [UIImage imageNamed:@"recipt14"];
                        [myCellView addSubview: imageView];
                        
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, self.view.frame.size.width , 40)];
                        label.textColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1];
                        label.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
                        label.text = [NSString stringWithFormat:@"人均: %@",[_dict objectForKey:@"price"]];
                        
                        [myCellView addSubview:label];
                        break;
                    }
                    case SUBCATEGORY:
                    {
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 14, 14)];
                        imageView.image = [UIImage imageNamed:@"tag14"];
                        [myCellView addSubview: imageView];
                        
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, self.view.frame.size.width , 40)];
                        label.textColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1];
                        label.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
                        NSString *subcategorys = [[[_dict objectForKey:@"subcategory"] valueForKey:@"description"] componentsJoinedByString:@", "];
                        
                        label.text = subcategorys;
                        
                        [myCellView addSubview:label];
                        break;
                    }
                    case DESCRIPTION:
                    {
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, self.view.frame.size.width - 30 , myCellView.contentView.frame.size.height)];
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
                
                // name
                UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, 100, 20)];
                name.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:12];
                name.textColor = [UIColor colorWithRed:0.9 green:0.56 blue:0.12 alpha:1];
                name.text = [reviewDict objectForKey:@"user"];
                
                [myCellView addSubview:name];
                
                // date
                UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100 - 15, 10, 100, 20)];
                
                date.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:12];
                date.textColor = [UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1];
                date.text = [reviewDict objectForKey:@"date"];
                date.textAlignment = NSTextAlignmentRight;
                
                [myCellView addSubview:date];
                
                // avatar
                UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 30, 30)];
                avatar.clipsToBounds = YES;
                avatar.layer.cornerRadius = 10;
                
                // start a new image download manager
                NSURL *photo_URL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",[reviewDict objectForKey:@"avatar"]]];
                [avatar sd_setImageWithURL:photo_URL];
                
                [myCellView addSubview:avatar];

                
                // review
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15 + 40, 30, self.view.frame.size.width - 15 - 40 - 15 , myCellView.contentView.frame.size.height)];
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
                break;
            }
            case MAPSECTION:
            {
                // 地图
                _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
                _mapView.showsUserLocation = YES;
                _mapView.showsPointsOfInterest = NO;
                _mapView.delegate = self;
                
                [myCellView addSubview:_mapView];
                
                // location manager
                _locationManager = [[CLLocationManager alloc] init];
                _locationManager.delegate = self;
                if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                    [self.locationManager requestWhenInUseAuthorization];
                }
                [_locationManager startUpdatingLocation];
                
                // set region and zoom
                CLLocationCoordinate2D startCoord;
                startCoord.latitude = [[_dict objectForKey:@"latitude"] doubleValue];
                startCoord.longitude = [[_dict objectForKey:@"longitude"] doubleValue];
                [_mapView setRegion:MKCoordinateRegionMakeWithDistance(startCoord, 100, 100) animated:YES];
                
                // marker
                MarkerAnnotation *marker = [[MarkerAnnotation alloc] initWithLocation:startCoord title:@"" subTitle:@""];
                [_mapView addAnnotation:marker];
                
                // focus button
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
                button.layer.cornerRadius = 18.0f;
                button.clipsToBounds = YES;
                [button setImage:[UIImage imageNamed:@"marker"] forState:UIControlStateNormal];
                button.backgroundColor = [UIColor colorWithRed:0.99 green:0.65 blue:0.18 alpha:0.9];
                [button addTarget:self action:@selector(focusMe) forControlEvents:UIControlEventTouchUpInside];
                
                [myCellView addSubview:button];
                
                // address detail
                UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, self.view.frame.size.width - 20, 40)];
                [address setText:[NSString stringWithFormat:@"%@ %@ %@",[_dict objectForKey:@"street1"],[_dict objectForKey:@"city"],[_dict objectForKey:@"postcode"]]];
                [address setFont:[UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14]];
                [address setBackgroundColor:[UIColor colorWithRed:0.63 green:0.75 blue:0.16 alpha:.9]];
                [address setTextColor:[UIColor whiteColor]];
                [address.layer setCornerRadius:14.0];
                [address setClipsToBounds:YES];
                [address setTextAlignment:NSTextAlignmentCenter];
                [myCellView addSubview:address];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMap)];
                [myCellView addGestureRecognizer:tap];
                
                break;
            }
            default:
                break;
        }
    }
    
    myCellView.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return myCellView;
}

#pragma mark - action

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == REVIEWSECTION) {
        NSDictionary *dict = [_reviewArray objectAtIndex:indexPath.row];
        NSString *username = [dict objectForKey:@"username"];
        UserTableViewController *userVC = [[UserTableViewController alloc] initWithUsername:username];
        [self.navigationController pushViewController:userVC animated:YES];
    }
}

- (void)chooseUserOrSignin {
    if (self.checkLoginStatus) {
        [self redirectToReviewView];
    } else {
        [self redirectToSigninView];
    }
}

- (void)redirectToReviewView {
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [userInfo objectForKey:@"userinfo"];
    NSInteger userID = [[dict objectForKey:@"id"] integerValue];
    
    ReviewTableViewController *vc = [[ReviewTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [vc setRestaurantID: [[_dict objectForKey:@"id"] integerValue]];
    [vc setUserID:userID];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)redirectToSigninView {
    SigninTableViewController *vc = [[SigninTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)checkLoginStatus {
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSString *username = [userInfo objectForKey:@"username"];
    if (username) {
        return YES;
    } else {
        return NO;
    }
}

- (void)focusMe {
    MKCoordinateRegion region;
    region.center = _mapView.userLocation.coordinate;
    region.span = MKCoordinateSpanMake(0.001, 0.001);
    
    region = [_mapView regionThatFits:region];
    [_mapView setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Marker"];
    
    if ([annotation isKindOfClass:[MarkerAnnotation class]]) {
        
        annotationView.image = [UIImage imageNamed:@"mapannotation"];
        
        //annotationView.animatesDrop = YES;
        
        annotationView.canShowCallout = NO;
        
    } else {
        annotationView.canShowCallout = NO;
        annotationView = nil;
    }
    return annotationView;
}

- (void)openMap {
    NSString *nativeMapScheme = @"maps.apple.com";
    NSString* addressString = [NSString stringWithFormat:@"http://%@/maps?q=%@,%@", nativeMapScheme, [_dict objectForKey:@"latitude"], [_dict objectForKey:@"longitude"]];
    NSURL *url = [NSURL URLWithString:addressString];
    [[UIApplication sharedApplication] openURL:url];
}


@end
