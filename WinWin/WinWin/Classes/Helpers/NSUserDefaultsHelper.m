//
//  NSUserDefaultsHelper.m
//  WinWin
//
//  Created by Othonas Antoniou on 6/13/15.
//  Copyright (c) 2015 GENERiO. All rights reserved.
//

#import "NSUserDefaultsHelper.h"

#import "WINUser.h"

static NSString * const kNSUserDefaultsHelperUserKey = @"kNSUserDefaultsHelperUserKey";

@implementation NSUserDefaultsHelper

+ (void)SaveUser:(WINUser *)user
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
    [defaults setObject:data forKey:kNSUserDefaultsHelperUserKey];
    [defaults synchronize];
}

+ (WINUser *)GetUser
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUserDefaultsHelperUserKey];
    WINUser *user = (WINUser *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    return user;
}

+ (void)ClearUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kNSUserDefaultsHelperUserKey];
    [defaults synchronize];
}

@end
