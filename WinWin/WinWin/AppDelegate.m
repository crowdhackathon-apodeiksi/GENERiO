//
//  AppDelegate.m
//  WinWin
//
//  Created by CHARALAMPOS SPYROPOULOS on 6/9/15.
//  Copyright (c) 2015 GENERiO. All rights reserved.
//

#import "AppDelegate.h"

#import <Parse/Parse.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Parse setApplicationId:@"NJchMUp3VncVpCU4VVSe5iS2IrxMgS89PIf0DTcS" clientKey:@"MveaVrRert9xXH1OdWIj4QHuSkUHUPhYBkMcuaxV"];
    
    [self p_applyAppearance];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Private

- (void)p_applyAppearance
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor orangeColor]];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor orangeColor],
                                                           NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20.0f],
                                                           }];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes: @{
                                                                                                        NSForegroundColorAttributeName: [UIColor orangeColor],
                                                                                                        NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]
                                                                                                        } forState:UIControlStateNormal];
    
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD setForegroundColor:[UIColor orangeColor]];
    [SVProgressHUD setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f]];
    
}

@end