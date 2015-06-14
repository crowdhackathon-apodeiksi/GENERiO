//
//  WINManualReceiptEntryViewController.m
//  WinWin
//
//  Created by Othonas Antoniou on 6/14/15.
//  Copyright (c) 2015 GENERiO. All rights reserved.
//

#import "WINManualReceiptEntryViewController.h"

#import "UIImage+Extensions.h"

@interface WINManualReceiptEntryViewController ()

@property(nonatomic,weak) IBOutlet UIButton *btnSave;

@end

@implementation WINManualReceiptEntryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.btnSave setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:self.btnSave.bounds.size] forState:UIControlStateNormal];
}

@end
