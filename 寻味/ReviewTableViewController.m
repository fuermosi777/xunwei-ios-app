//
//  ReviewTableViewController.m
//  Xunwei
//
//  Created by Hao Liu on 11/22/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#define INPUTSECTION 0
#define ACTIONSECTION 3
#define STARSECTION 1
#define PRICESECTION 2

#define REVIEWFIELD 0

#import "ReviewTableViewController.h"
#import "JSFavStarControl.h"
#import "AlertView.h"

@interface ReviewTableViewController () <UITextViewDelegate>

@end

@implementation ReviewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionName;
    switch (section)
    {
        case INPUTSECTION:
            sectionName = @"评价";
            break;
        case ACTIONSECTION:
            break;
        case STARSECTION:
            sectionName = @"打个分吧";
            break;
        case PRICESECTION:
            sectionName = @"价格怎么样? (人均价格)";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"Cell"];
    switch (indexPath.section) {
        case INPUTSECTION:
        {
            switch (indexPath.row) {
                case 0:
                {
                    UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(15, 15, cell.contentView.frame.size.width - 30, 170)];
                    text.attributedText = [[NSAttributedString alloc] initWithString:@""
                                                                                      attributes:@{
                                                                                                   NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                                                                                   NSFontAttributeName : [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14.0],
                                                                                                   }];
                    text.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
                    text.tag = REVIEWFIELD;
                    text.delegate = self;
                    
                    [cell addSubview:text];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case ACTIONSECTION:
        {
            UIButton *button = [[UIButton alloc] initWithFrame:cell.bounds];
            button.backgroundColor = [UIColor colorWithRed:0.63 green:0.75 blue:0.16 alpha:.9];
            button.titleLabel.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
            [button setTitle:@"发表" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.tag = REVIEWFIELD;
            [button addTarget:self action:@selector(saveReview) forControlEvents:UIControlEventTouchUpInside];
            
            [cell addSubview:button];
            break;
        }
        case STARSECTION:
        {
            _control = [[JSFavStarControl alloc] initWithLocation:CGPointMake((self.view.frame.size.width - 200) / 2.0, 5)
                                                                          dotImage:[UIImage imageNamed:@"marker14"]
                                                                         starImage:[UIImage imageNamed:@"marker14"]];
                        [cell addSubview:_control];
            
            _control.delegate = self;
            _star = _control.rating; // init star value
            
            _starLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 115, -25, 100, 20)];
            _starLabel.textColor = [UIColor blackColor];
            _starLabel.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:12.0];
            _starLabel.textColor = [UIColor orangeColor];
            _starLabel.textAlignment = NSTextAlignmentRight;
            
            [cell addSubview:_starLabel];
            
            break;
        }
        case PRICESECTION:
        {
            UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 200) / 2.0, 0, 200, 40)];
            [slider setMinimumValue:1];
            [slider setMaximumValue:5];
            [slider setTintColor:[UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1]];
            [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
            
            _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 115, -25, 100, 20)];
            _priceLabel.textColor = [UIColor blackColor];
            _priceLabel.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:12.0];
            _priceLabel.textColor = [UIColor orangeColor];
            _priceLabel.textAlignment = NSTextAlignmentRight;
            
            [cell addSubview:_priceLabel];
            _price = slider.value; // init value
            
            [cell addSubview:slider];
            break;
        }
        default:
        {

            break;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)sliderChanged:(UISlider *)sender {
    _price = sender.value;
    NSString *text = [NSString new];
    if (_price < 1.5) {
        text = @"低于$10";
    } else if (_price < 2.5 && _price >= 1.5 ) {
        text = @"$10 - $30";
    } else if (_price < 3.5 && _price >= 2.5 ) {
        text = @"$30 - $50";
    } else if (_price < 4.5 && _price >= 3.5 ) {
        text = @"$50 - $80";
    } else if (_price <= 5 ) {
        text = @"$80以上";
    }
    _priceLabel.text = text;
}

- (void)receiveRating:(NSInteger)rating {
    _star = rating;
    NSString *text = [NSString new];
    switch (rating) {
        case 1:
            text = @"以后不会再去了";
            break;
        case 2:
            text = @"不是很好吃";
            break;
        case 3:
            text = @"味道一般";
            break;
        case 4:
            text = @"很好吃";
            break;
        case 5:
            text = @"人间美味";
            break;
        default:
            break;
    }
    _starLabel.text = text;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger rowHeight;
    switch (indexPath.section) {
        case INPUTSECTION:
        {
            rowHeight = 200;
            break;
        }
        default:
        {
            rowHeight = 40;
            break;
        }
    }
    return rowHeight;
}

#pragma mark - text field deledate

- (void)textViewDidEndEditing:(UITextView *)textView {
    _review = textView.text;
    
}

#pragma mark - action

- (void)saveReview {
    [self.view endEditing:YES];
    NSLog(@"%@ %li %li",_review,_price,_star);
    if (!_review || !_price || !_star) {
        AlertView *alert = [[AlertView alloc] init];
        [alert showCustomErrorWithTitle:@"错误" message:@"评价，评分或者价格没有选择" cancelButton:@"确定"];
        return;
    }
    if (_review.length < 10) {
        AlertView *alert = [[AlertView alloc] init];
        [alert showCustomErrorWithTitle:@"注意" message:@"低于十个字的评价可能不会显示" cancelButton:@"确定"];
        return;
    }
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSString *username = [userInfo objectForKey:@"username"];
    NSString *password = [userInfo objectForKey:@"password"];

    // 1 start a post data
    NSString *post = [NSString stringWithFormat:@"username=%@&password=%@&review=%@&star=%li&price=%li&restaurantID=%li",username,password,_review,_star,_price,_restaurantID];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding
                          allowLossyConversion:YES];
    NSLog(@"%@",post);
    // 2 get data length
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    // 3 create url request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://xun-wei.com/app/review/"];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    // 4 create connection
    __unused NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request
                                                                    delegate:self
                                                            startImmediately:YES];
}

#pragma mark - conntection delegate

// data receive part
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    incomingData = nil;
    if (!incomingData) {
        incomingData = [[NSMutableData alloc] init];
    }
    
    [incomingData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    AlertView *alert = [[AlertView alloc] init];
    [alert showCustomErrorWithTitle:@"错误" message:@"网络连接错误" cancelButton:@"确定"];
}

// 数据全部接受完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:incomingData
                                                                options:kNilOptions
                                                                  error:&error];
    NSInteger status = [[dict objectForKey:@"status"] integerValue];
    NSString *msg = [NSString stringWithFormat:@"%@", [dict objectForKey:@"msg"]];

    if (status == 1) { // login success
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } else { // unexplained error
        AlertView *alert = [[AlertView alloc] init];
        [alert showCustomErrorWithTitle:@"错误" message:msg cancelButton:@"确定"];
        
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
