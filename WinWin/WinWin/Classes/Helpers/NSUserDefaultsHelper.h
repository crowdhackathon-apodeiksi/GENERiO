//
//  NSUserDefaultsHelper.h
//  WinWin
//
//  Created by Othonas Antoniou on 6/13/15.
//  Copyright (c) 2015 GENERiO. All rights reserved.
//

@import Foundation;

@class WINUser;

@interface NSUserDefaultsHelper : NSObject

+ (void)SaveUser:(WINUser *)user;
+ (WINUser *)GetUser;
+ (void)ClearUser;

@end
