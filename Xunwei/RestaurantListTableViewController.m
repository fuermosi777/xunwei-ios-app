//
//  RestaurantListTableViewController.m
//  Xunwei
//
//  Created by Hao Liu on 12/11/14.
//  Copyright (c) 2014 Hao Liu. All rights reserved.
//
#define LISTITEMHEIGHT 80

#import "RestaurantListTableViewController.h"
#import "ListItemView.h"
#import "DetailViewController.h"

@interface RestaurantListTableViewController ()

@end

@implementation RestaurantListTableViewController

- (id)initWithArray:(NSArray *)array {
    self = [super init];
    if (self) {
        _array = array;
    }
    return self;
}

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
    return [_array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger rowHeight = LISTITEMHEIGHT;
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // edit cell
    NSMutableDictionary *dict = [_array objectAtIndex:indexPath.row];
    ListItemView *listItemView = [[ListItemView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, LISTITEMHEIGHT)
                                                          dataSource:dict];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(redirectToDetailView:)];
    listItemView.tag = [[dict objectForKey:@"id"] intValue];
    
    [listItemView addGestureRecognizer:tap];
    [listItemView setUserInteractionEnabled:YES];
    
    [cell addSubview:listItemView];
    return cell;
}

- (void)redirectToDetailView:(UITapGestureRecognizer *)tap {
    NSInteger ID = tap.view.tag;
    
    DetailViewController *vc = [[DetailViewController alloc] initWithID:ID];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
