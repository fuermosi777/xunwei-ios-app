//
//  UserTableViewController.m
//  Xunwei
//
//  Created by Hao Liu on 11/21/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//

#define ACTIONSECTION 0

#import "UserTableViewController.h"

@interface UserTableViewController ()

@end

@implementation UserTableViewController

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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"Cell"];
    switch (indexPath.section) {
        case ACTIONSECTION:
        {
            switch (indexPath.row) {
                case 0:
                {
                    UIButton *button = [[UIButton alloc] initWithFrame:cell.bounds];
                    [button setBackgroundColor:[UIColor colorWithRed:0.93 green:0.31 blue:0.18 alpha:1]];
                    [button setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                    [button setTitle:@"登出" forState:UIControlStateNormal];
                    [button.titleLabel setFont:[UIFont fontWithName:@"XinGothic-CiticPress-Regular" size:14]];
                    [button addTarget:self action:@selector(signout) forControlEvents:UIControlEventTouchUpInside];
                    
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
    // Configure the cell...
    
    return cell;
}

- (void)signout {
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    [userInfo removeObjectForKey:@"username"];
    [userInfo removeObjectForKey:@"password"];
    
    [userInfo synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
