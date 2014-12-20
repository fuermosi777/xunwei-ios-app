//
//  UserTableViewController.m
//  Xunwei
//
//  Created by Hao Liu on 11/21/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#define ACTIONSECTION 3
#define INFOSECTION 1
#define AVATARSECTION 0
#define REVIEWSECTION 2

#define AVATARWIDTH 80

#import "UserTableViewController.h"
#import "AlertView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ImagePickerController.h"
#import <AFNetworking.h>
#import "RestaurantListTableViewController.h"
#import "AboutTableViewController.h"
#import <MBProgressHUD/MBProgressHUD.h> // progress indicator

@interface UserTableViewController ()

@end

@implementation UserTableViewController

- (id)initWithUsername:(NSString *)username {
    self = [super initWithStyle: UITableViewStyleGrouped];
    if (self) {
        _username = username;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - load data
- (void)loadData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 1 start a post data
        NSString *post = [NSString stringWithFormat:@"username=%@",_username];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding
                              allowLossyConversion:YES];
        // 2 get data length
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        // 3 create url request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *url = [NSURL URLWithString:@"http://xun-wei.com/app/user/"];
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
                [hud hide:YES];
                NSError *error;
                NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:kNilOptions
                                                                              error:&error];
                NSInteger status = [[dict objectForKey:@"status"] integerValue];
                NSString *msg = [NSString stringWithFormat:@"%@", [dict objectForKey:@"msg"]];
                NSDictionary *info = [dict objectForKey:@"info"];
                
                if (status == 1) { // login success
                    _dict = info;
                    _reviewArray = [_dict objectForKey:@"reviews"];
                    
                    [self.tableView reloadData];
                    
                } else { // unexplained error
                    
                    AlertView *alert = [[AlertView alloc] init];
                    [alert showCustomErrorWithTitle:@"错误" message:msg cancelButton:@"确定"];
                    
                }
            });
        } else {
            [hud hide:YES];
            NSLog(@"error!");
        }
        
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNum;
    switch (section) {
        case AVATARSECTION:
        {
            rowNum = 1;
            break;
        }
        case REVIEWSECTION:
        {
            if (_dict) {
                rowNum = [_reviewArray count];
            } else {
                rowNum = 1;
            }
            break;
        }
        case INFOSECTION:
        {
            rowNum = 3;
            break;
        }
        case ACTIONSECTION:
        {
            rowNum = 2;
            break;
        }
        default:
        {
            rowNum = 1;
            break;
        }
    }
    return rowNum;
}

// section title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionName;
    switch (section)
    {
        case REVIEWSECTION:
            sectionName = @"评论过的餐厅";
            break;
        case INFOSECTION:
            sectionName = @"基本信息";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger rowHeight;
    switch (indexPath.section) {
        case AVATARSECTION:
        {
            rowHeight = 164;
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
            rowHeight = expectedLabelSize.size.height + 26 + 25;
            break;
        }
        default:
        {
            rowHeight = 44;
            break;
        }
    }
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"Cell"];
    if (_dict) {
        switch (indexPath.section) {
            case AVATARSECTION:
            {
                UIImageView *avatar = [[UIImageView alloc] initWithFrame: CGRectMake((self.view.frame.size.width - AVATARWIDTH)/2, 20, AVATARWIDTH, AVATARWIDTH)];
                [avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [_dict objectForKey:@"avatar"]]]];
                [avatar.layer setCornerRadius:26];
                [avatar setClipsToBounds:YES];
                
                [cell addSubview:avatar];
                
                
                NSString *username = [NSString stringWithFormat:@"%@", [_dict objectForKey:@"username"]];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40 + AVATARWIDTH, self.view.frame.size.width, 20)];
                [label setText:username];
                [label setTextAlignment:NSTextAlignmentCenter];
                [label setFont:[UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14]];
                
                if (_dict) {
                    [cell addSubview:label];
                }
                
                break;
            }
            case INFOSECTION: {
                switch (indexPath.row) {
                    case 0:
                    {
                        if (_dict){
                            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 14, 14)];
                            imageView.image = [UIImage imageNamed:@"clock14"];
                            [cell addSubview: imageView];
                            
                            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, self.view.frame.size.width , 40)];
                            label.textColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1];
                            label.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
                            label.text = [NSString stringWithFormat:@"加入时间: %@", [_dict objectForKey:@"date_joined"]];
                            
                            [cell addSubview:label];
                        }
                        break;
                    }
                    case 1:
                    {
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 14, 14)];
                        imageView.image = [UIImage imageNamed:@"star14"];
                        [cell addSubview: imageView];
                        
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, self.view.frame.size.width , 40)];
                        label.textColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1];
                        label.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
                        label.text = [NSString stringWithFormat:@"收藏: %@", [_dict objectForKey:@"liked_num"]];
                        
                        [cell addSubview:label];
                        
                        // touch event
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(redirectToRestaurantListView)];
                        [cell addGestureRecognizer:tap];
                        
                        break;
                    }
                    case 2:
                    {
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 14, 14)];
                        imageView.image = [UIImage imageNamed:@"review14"];
                        [cell addSubview: imageView];
                        
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, self.view.frame.size.width , 40)];
                        label.textColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1];
                        label.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
                        label.text = [NSString stringWithFormat:@"评论: %@", [_dict objectForKey:@"review_num"]];
                        
                        [cell addSubview:label];
                        break;
                    }
                    default:
                        break;
                }
                break;
            }
            case ACTIONSECTION: {
                switch (indexPath.row) {
                    case 0:
                    {
                        UIButton *button = [[UIButton alloc] initWithFrame:cell.bounds];
                        [button setBackgroundColor:[UIColor clearColor]];
                        [button setTitleColor: [UIColor grayColor] forState:UIControlStateNormal];
                        [button setTitle:@"登出" forState:UIControlStateNormal];
                        [button.titleLabel setFont:[UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14]];
                        [button addTarget:self action:@selector(signout) forControlEvents:UIControlEventTouchUpInside];
                        
                        [cell addSubview:button];
                        
                        break;
                    }
                    case 1:
                    {
                        UIButton *button = [[UIButton alloc] initWithFrame:cell.bounds];
                        [button setBackgroundColor:[UIColor clearColor]];
                        [button setTitleColor: [UIColor grayColor] forState:UIControlStateNormal];
                        [button setTitle:@"关于" forState:UIControlStateNormal];
                        [button.titleLabel setFont:[UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14]];
                        [button addTarget:self action:@selector(redirectToAboutView) forControlEvents:UIControlEventTouchUpInside];
                        
                        [cell addSubview:button];
                        
                        break;
                    }
                    default:
                        break;
                }
                break;
            }
            case REVIEWSECTION:
            {
                if (_dict) {
                    NSMutableDictionary *reviewDict = [_reviewArray objectAtIndex:indexPath.row];
                    
                    // name
                    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, 100, 20)];
                    name.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:12];
                    name.textColor = [UIColor colorWithRed:0.9 green:0.56 blue:0.12 alpha:1];
                    name.text = [reviewDict objectForKey:@"restaurant_name"];
                    
                    [cell addSubview:name];
                    
                    // date
                    UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100 - 15, 10, 100, 20)];
                    
                    date.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:12];
                    date.textColor = [UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1];
                    date.text = [reviewDict objectForKey:@"review_date"];
                    date.textAlignment = NSTextAlignmentRight;
                    
                    [cell addSubview:date];
                    
                    // avatar
                    UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 30, 30)];
                    avatar.clipsToBounds = YES;
                    avatar.layer.cornerRadius = 10;
                    
                    // start a new image download manager
                    NSURL *photo_URL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",[reviewDict objectForKey:@"restaurant_photo"]]];
                    [avatar sd_setImageWithURL:photo_URL];
                    
                    [cell addSubview:avatar];
                    
                    
                    // review
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15 + 40, 30, self.view.frame.size.width - 15 - 40 - 15 , cell.contentView.frame.size.height)];
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
                    
                    [cell addSubview:label];
                } else {
                    cell.textLabel.text = @"暂无评论";
                    cell.textLabel.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
                }
                break;
            }
            default:
                break;
        }
    }
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)signout {
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    [userInfo removeObjectForKey:@"username"];
    [userInfo removeObjectForKey:@"password"];
    
    [userInfo synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

# pragma mark - actions
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == AVATARSECTION) {
        if (self.checkSelf){
            [self uploadPhoto];
        }
    }
}

- (void)uploadPhoto {
    ImagePickerController *picker = [[ImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSString *username = [userInfo objectForKey:@"username"];
    NSString *password = [userInfo objectForKey:@"password"];
    NSDictionary *param = @{@"username":username,
                            @"password":password};
    
    [manager POST:@"http://xun-wei.com/app/userprofile/"
       parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imageData
                                       name:@"avatar"
                                   fileName:@"avatar.jpg"
                                   mimeType:@"image/jpeg"];
       }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"Success: %@", responseObject);
              NSDictionary *dict = responseObject;

              NSInteger status = [[dict objectForKey:@"status"] integerValue];
              NSString *msg = [NSString stringWithFormat:@"%@", [dict objectForKey:@"msg"]];
              NSDictionary *userInfoDict = [dict objectForKey:@"info"];
              
              if (status == 1) { 
                  // reset user avatar
                  NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
                  [userInfo setValue:userInfoDict forKey:@"userinfo"];
                  [userInfo synchronize];
                  
                  [self loadData];
              } else {
                  AlertView *alert = [[AlertView alloc] init];
                  [alert showCustomErrorWithTitle:@"错误" message:msg cancelButton:@"确定"];
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

// check if the user is myself
- (BOOL)checkSelf {
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSString *username = [userInfo objectForKey:@"username"];
    if (username == _username) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark - redirect
- (void)redirectToRestaurantListView {
    NSArray *array = [_dict objectForKey:@"liked"];
    RestaurantListTableViewController *vc = [[RestaurantListTableViewController alloc] initWithArray:array];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)redirectToAboutView {
    AboutTableViewController *vc = [[AboutTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
