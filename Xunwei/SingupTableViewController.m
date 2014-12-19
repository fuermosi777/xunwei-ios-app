//
//  SingupTableViewController.m
//  Xunwei
//
//  Created by Hao Liu on 11/22/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#define INPUTSECTION 0
#define ACTIONSECTION 1

#define USERNAMEFIELD 0
#define PASSWORDFIELD 1
#define EMAILFIELD 2

#import "SingupTableViewController.h"
#import "AlertView.h"

@interface SingupTableViewController ()

@end

@implementation SingupTableViewController

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger sectionNum;
    switch (section) {
        case INPUTSECTION:
        {
            sectionNum = 3;
            break;
        }
        case ACTIONSECTION:
        {
            sectionNum = 1;
            break;
        }
            
        default:
            break;
    }
    return sectionNum;
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
                    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, cell.frame.size.width - 30, cell.frame.size.height)];
                    textField.autocapitalizationType = UITextAutocapitalizationTypeNone; // first letter capitalization disable
                    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"用户名"
                                                                                      attributes:@{
                                                                                                   NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                                                                                   NSFontAttributeName : [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14.0],
                                                                                                   }];
                    textField.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
                    [cell addSubview:textField];
                    textField.tag = USERNAMEFIELD;
                    textField.delegate = self;
                    break;
                }
                case 1:
                {
                    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, cell.frame.size.width - 30, cell.frame.size.height)];
                    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码"
                                                                                      attributes:@{
                                                                                                   NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                                                                                   NSFontAttributeName : [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14.0],
                                                                                                   }];
                    textField.secureTextEntry = YES;
                    textField.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
                    [cell addSubview:textField];
                    textField.tag = PASSWORDFIELD;
                    textField.delegate = self;
                    break;
                }
                case 2:
                {
                    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, cell.frame.size.width - 30, cell.frame.size.height)];
                    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email地址"
                                                                                      attributes:@{
                                                                                                   NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                                                                                   NSFontAttributeName : [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14.0],
                                                                                                   }];
                    textField.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
                    [cell addSubview:textField];
                    textField.tag = EMAILFIELD;
                    textField.delegate = self;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case ACTIONSECTION:
        {
            switch (indexPath.row) {
                case 0:
                {
                    _signupButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
                    _signupButton.backgroundColor = [UIColor colorWithRed:0.63 green:0.75 blue:0.16 alpha:.9];
                    _signupButton.titleLabel.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
                    [_signupButton setTitle:@"注册新账户" forState:UIControlStateNormal];
                    [_signupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [_signupButton addTarget:self action:@selector(signup) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:_signupButton];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - text field deledate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // determine which textfield
    if (textField.tag == USERNAMEFIELD) {
        _username = textField.text;
    } else if (textField.tag == PASSWORDFIELD) {
        _password = textField.text;
    } else if (textField.tag == EMAILFIELD) {
        _email = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == EMAILFIELD) {
        [textField resignFirstResponder];
        [self signup];
        return YES;
    }
    return NO;
}

#pragma mark - action part

- (void)signup {
    [self.view endEditing:YES];
    
    if (_username && _password && _email) {
        // disable button
        [self disableButton];
        
        // 1 start a post data
        NSString *post = [NSString stringWithFormat:@"username=%@&password=%@&email=%@",self.username,self.password,_email];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding
                              allowLossyConversion:YES];
        // 2 get data length
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        // 3 create url request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *url = [NSURL URLWithString:@"http://xun-wei.com/app/signup/"];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        // 4 create connection
        __unused NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request
                                                                        delegate:self
                                                                startImmediately:YES];
    } else {
        AlertView *alert = [[AlertView alloc] init];
        [alert showCustomErrorWithTitle:@"错误" message:@"信息填写不正确" cancelButton:@"确定"];
    }
}

#pragma mark - button action
- (void)disableButton {
    // disable button
    _signupButton.userInteractionEnabled = NO;
    _signupButton.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
}

- (void)enableButton {
    _signupButton.userInteractionEnabled = YES;
    _signupButton.backgroundColor = [UIColor colorWithRed:0.63 green:0.75 blue:0.16 alpha:1];
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
    NSMutableDictionary *userinfo = [dict objectForKey:@"userinfo"];
    
    if (status == 1) { // login success
        NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
        [userInfo setValue:self.username forKey:@"username"];
        [userInfo setValue:self.password forKey:@"password"];
        [userInfo setValue:userinfo forKey:@"userinfo"];
        
        [userInfo synchronize];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } else { // unexplained error
        // enable button
        [self enableButton];
        
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
