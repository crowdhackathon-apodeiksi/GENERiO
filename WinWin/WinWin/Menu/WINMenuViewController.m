//
//  WINMenuViewController.m
//  WinWin
//
//  Created by CHARALAMPOS SPYROPOULOS on 6/13/15.
//  Copyright (c) 2015 GENERiO. All rights reserved.
//

#import "WINMenuViewController.h"

#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "WINUser.h"
#import "NSUserDefaultsHelper.h"
#import "WINAlarm.h"
#import "WINImageMockViewController.h"
#import "UIImage+Extensions.h"
#import "WINSettingsViewController.h"

@interface WINMenuViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnCoupons;
@property (weak, nonatomic) IBOutlet UIButton *btnMessages;
@property (weak, nonatomic) IBOutlet UIButton *btnProfile;
@property (weak, nonatomic) IBOutlet UIButton *btnEntry;

@end

@implementation WINMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"WinWin";
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithImage:[UIImage imageNamed:@"icon_settings"] overlayColor:[UIColor orangeColor]] style:UIBarButtonItemStylePlain target:self action:@selector(p_barBtnSettingsPressed:)];
    
    self.btnEntry.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.btnEntry.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.btnEntry setTitle: @"Καταχώρηση\nΑποδείξεων" forState: UIControlStateNormal];
    
    [self p_fetchTags];
    [self p_fetchAlarms];
}

- (IBAction)btnCouponsPressed:(id)sender
{
    WINImageMockViewController *controller = (WINImageMockViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ImageMockViewController"];
    controller.title = @"Κουπόνια";
    controller.image = [UIImage imageNamed:@"mock_coupons"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)btnMessagesPressed:(id)sender
{
    WINImageMockViewController *controller = (WINImageMockViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ImageMockViewController"];
    controller.title = @"Μηνύματα";
    controller.image = [UIImage imageNamed:@"mock_messages"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)p_barBtnSettingsPressed:(id)sender
{
    WINSettingsViewController *controller = (WINSettingsViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)p_fetchAlarms
{
    WINUser *user = [NSUserDefaultsHelper GetUser];
    
    PFQuery *customerQuery = [PFQuery queryWithClassName:@"CUSTOMER"];
    [customerQuery whereKey:@"VAT" equalTo:user.vat];
    [customerQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error) {
            return;
        }
        
        if (objects.count == 0) {
            return;
        }
        
        PFObject *customer = (PFObject *)objects[0];
        
        PFQuery *alarmsQuery = [PFQuery queryWithClassName:@"ALARMS"];
        [alarmsQuery whereKey:@"CUSTOMER_ID" equalTo:customer];
        [alarmsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (error) {
                return;
            }
            
            if (objects.count == 0) {
                return;
            }
            
            PFObject *pfAlarm = (PFObject *)objects[0];
            
            WINAlarm *winAlarm = [[WINAlarm alloc] init];
            winAlarm.value = [pfAlarm[@"VALUE"] floatValue];
            winAlarm.operator = pfAlarm[@"OPERATOR"];
            winAlarm.days = [pfAlarm[@"DAYS"] integerValue];
            winAlarm.tag = pfAlarm[@"TAG_ID"];
            
            ((AppDelegate *)[[UIApplication sharedApplication] delegate]).alarm = winAlarm;
        }];

    }];

    
}

- (void)p_fetchTags
{
    PFQuery *tagsQuery = [PFQuery queryWithClassName:@"TAG"];
    [tagsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error) {
            return;
        }
        
        if (objects.count == 0) {
            return;
        }
        
        //NSArray *tags = [objects valueForKeyPath:@"@distinctUnionOfObjects.SHORT_DESCRIPTION"];
        NSArray *tags = objects;
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).receiptTags = tags;
        
    }];
}

@end
