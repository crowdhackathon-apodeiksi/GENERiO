//
//  AppDelegate.h
//  WinWin
//
//  Created by CHARALAMPOS SPYROPOULOS on 6/9/15.
//  Copyright (c) 2015 GENERiO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WINAlarm.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong) NSArray *receiptTags;
@property(nonatomic,strong) WINAlarm *alarm;

@end

