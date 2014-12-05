//
//  AboutTableViewController.m
//  Xunwei
//
//  Created by Hao Liu on 11/23/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#define ABOUTSECTION 0
#define CONTACTSECTION 1
#define VERSIONSECTION 2

#import "AboutTableViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface AboutTableViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation AboutTableViewController

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger rowHeight;
    switch (indexPath.section) {
        case ABOUTSECTION:
        {
            rowHeight = 280;
            break;
        }
        case CONTACTSECTION:
        {
            rowHeight = 44;
            break;
        }
        case VERSIONSECTION:
        {
            rowHeight = 44;
            break;
        }
            default:
                break;
    }
    return rowHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionName;
    switch (section)
    {
        case ABOUTSECTION:
            sectionName = @"关于";
            break;
        case CONTACTSECTION:
            sectionName = @"联系";
            break;
        case VERSIONSECTION:
            sectionName = @"版本信息";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"Cell"];
    switch (indexPath.section) {
        case ABOUTSECTION:
        {
            switch (indexPath.row) {
                case 0:
                {
                    UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(15, 15, cell.contentView.frame.size.width - 30, 250)];
                    NSString *about = @"寻味纽约提供纽约地区最新鲜，最真实，最准确的美食信息。让每一个驻足纽约的吃货们都能快速发现自己熟悉和喜爱的味道；\n\n我们相信，每个吃货都是一部独一无二的美食自传；每次美食分享，背后都有难忘的瞬间。和家人，朋友一起欢聚的美好时刻，温暖海外游子的浓浓乡愁，在寻味你都能找到。\n\n熙熙攘攘的纽约街头，美食，寻味，是我们共同的符号。";
                    text.attributedText = [[NSAttributedString alloc] initWithString:about
                                                                          attributes:@{
                                                                                       NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                                                                       NSFontAttributeName : [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14.0],
                                                                                       }];
                    text.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
                    [text setEditable:NO];
                    [text setScrollEnabled:NO];
                    
                    [cell addSubview:text];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case CONTACTSECTION:
        {
            switch (indexPath.row) {
                case 0:
                {
                    UIButton *button = [[UIButton alloc] initWithFrame:cell.bounds];
                    button.titleLabel.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
                    [button setTitle:@"liuhao1990@gmail.com" forState:UIControlStateNormal];
                    [button setTitleColor: [UIColor grayColor] forState:UIControlStateNormal];
                    
                    [cell addSubview:button];
                    [button addTarget:self action:@selector(sendEmail) forControlEvents:UIControlEventTouchUpInside];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case VERSIONSECTION:
        {
            switch (indexPath.row) {
                case 0:
                {
                    UIButton *button = [[UIButton alloc] initWithFrame:cell.bounds];
                    button.titleLabel.font = [UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14];
                    [button setTitle:@"1.1.0" forState:UIControlStateNormal];
                    [button setTitleColor: [UIColor grayColor] forState:UIControlStateNormal];
                    
                    [cell addSubview:button];
                
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

#pragma mark - send email

- (void)sendEmail {
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setToRecipients: [NSMutableArray arrayWithObject:@"liuhao1990@gmail.com"]];
    [controller setSubject:@"意见建议"];
    [controller setMessageBody:@"" isHTML:NO];
    if (controller){
        [self presentViewController:controller animated:YES completion:^{}];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
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
