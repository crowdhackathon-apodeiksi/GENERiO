//
//  WINTagsListViewController.m
//  WinWin
//
//  Created by Othonas Antoniou on 6/14/15.
//  Copyright (c) 2015 GENERiO. All rights reserved.
//

#import "WINTagsListViewController.h"

#import <Parse/Parse.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "AppDelegate.h"

@interface WINTagsListViewController ()

@property(nonatomic,strong) NSArray *tags;

@end

@implementation WINTagsListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tags = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).receiptTags;
    
    for (PFObject *tag in self.selectedTags) {
        NSInteger index = [self.tags indexOfObject:tag];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TagTableViewCell" forIndexPath:indexPath];
    PFObject *tag = self.tags[indexPath.row];
    cell.textLabel.text = tag[@"SHORT_DESCRIPTION"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *tag = self.tags[indexPath.row];
    [self.selectedTags addObject:tag];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *tag = self.tags[indexPath.row];
    [self.selectedTags removeObject:tag];
}

@end
