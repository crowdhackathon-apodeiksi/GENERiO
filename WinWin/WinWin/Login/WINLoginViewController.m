//
//  WINLoginViewController.m
//  WinWin
//
//  Created by CHARALAMPOS SPYROPOULOS on 6/13/15.
//  Copyright (c) 2015 GENERiO. All rights reserved.
//

#import "WINLoginViewController.h"

#import <Parse/Parse.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "WINUser.h"
#import "NSUserDefaultsHelper.h"
#import "WINMenuViewController.h"

@interface WINLoginViewController ()

@property(nonatomic,weak) IBOutlet UITextField *txtAFM;
@property(nonatomic,weak) IBOutlet UITextField *txtKarta;
@property(nonatomic,weak) IBOutlet UIButton *btnLogin;

@end

@implementation WINLoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    WINUser *user = [NSUserDefaultsHelper GetUser];
    if (user) {
        WINMenuViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
        [self.navigationController pushViewController:controller animated:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"WinWin";
    
    [self.btnLogin setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:self.btnLogin.bounds.size] forState:UIControlStateNormal];
    
    self.txtAFM.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.txtAFM.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor orangeColor]}];
    self.txtKarta.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.txtKarta.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor orangeColor]}];
}

- (IBAction)btnLoginPressed:(id)sender
{
    NSString *vat = self.txtAFM.text;
    NSString *cardID = self.txtKarta.text;
    
    if (!vat.isValid || !cardID.isValid) {
        return;
    }
    
    [SVProgressHUD showWithStatus:@"Περιμένετε.." maskType:SVProgressHUDMaskTypeGradient];
    
    PFQuery *query = [PFQuery queryWithClassName:@"CUSTOMER"];
    [query whereKey:@"VAT" equalTo:@([vat integerValue])];
    [query whereKey:@"KARTA_ID" equalTo:@([cardID integerValue])];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"Σφάλμα" maskType:SVProgressHUDMaskTypeGradient];
            return ;
        }
        
        if (objects.count == 0) {
            [SVProgressHUD showErrorWithStatus:@"Λάθος Χρήστης" maskType:SVProgressHUDMaskTypeGradient];
            return;
        }
        
        PFObject *pfUser = (PFObject *)objects[0];
        
        WINUser *user = [[WINUser alloc] init];
        user.ID = pfUser.objectId;
        user.vat = pfUser[@"VAT"];
        user.cardID = pfUser[@"KARTA_ID"];
        user.name = pfUser[@"DESCRIPTION"];
        user.isSeller = [pfUser[@"IS_SELLER"] boolValue];
        
        [NSUserDefaultsHelper SaveUser:user];
        
        [SVProgressHUD dismiss];
        [self performSegueWithIdentifier:@"pushMenuFromLogin" sender:nil];
        
    }];
}

@end
