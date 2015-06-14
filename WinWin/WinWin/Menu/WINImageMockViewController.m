//
//  WINImageMockViewController.m
//  WinWin
//
//  Created by Othonas Antoniou on 6/14/15.
//  Copyright (c) 2015 GENERiO. All rights reserved.
//

#import "WINImageMockViewController.h"

@interface WINImageMockViewController ()

@property(nonatomic,weak) IBOutlet UIImageView *imgViewMock;

@end

@implementation WINImageMockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imgViewMock.image = self.image;
}

@end
