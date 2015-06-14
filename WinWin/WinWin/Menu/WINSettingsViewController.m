//
//  WINSettingsViewController.m
//  WinWin
//
//  Created by Othonas Antoniou on 6/14/15.
//  Copyright (c) 2015 GENERiO. All rights reserved.
//

#import "WINSettingsViewController.h"

#import "NSUserDefaultsHelper.h"

@interface WINSettingsViewController () <UIActionSheetDelegate>

@end

@implementation WINSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Ρυθμίσεις";
    
    UIView *viewBg = [[UIView alloc] initWithFrame:self.tableView.bounds];
    viewBg.backgroundColor = [UIColor orangeColor];
    self.tableView.backgroundView = viewBg;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)p_logout
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Θέλετε σίγουρα να αποσυνδεθείτε;" delegate:self cancelButtonTitle:@"Ακύρωση" destructiveButtonTitle:@"Αποσύνδεση" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [NSUserDefaultsHelper ClearUser];
        [self.navigationController popToRootViewControllerAnimated:NO];
        return;
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsTableViewCell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Ετικέτες";
            break;
        case 1:
            cell.textLabel.text = @"Ειδοποιήσεις";
            break;
        case 2:
            cell.textLabel.text = @"Αρχείο Αποδείξεων";
            break;
        case 3:
            cell.textLabel.text = @"Καμπάνιες";
            break;
        case 4:
            cell.textLabel.text = @"Εξαργύρωση";
            break;
        case 5:
            cell.textLabel.text = @"Αποσύνδεση";
            break;
        default:
            cell.textLabel.text = @"";
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
            break;
        case 5:
            [self p_logout];
            break;
        default:
            break;
    }
}

@end
