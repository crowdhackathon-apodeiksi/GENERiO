//
//  WINAlarm.h
//  WinWin
//
//  Created by CHARALAMPOS SPYROPOULOS on 6/14/15.
//  Copyright (c) 2015 GENERiO. All rights reserved.
//

@import Foundation;

#import <Parse/Parse.h>

@interface WINAlarm : NSObject

@property(nonatomic,assign) NSInteger days;
@property(nonatomic,assign) CGFloat value;
@property(nonatomic,strong) NSString *operator;
@property(nonatomic,assign) CGFloat counter;
@property(nonatomic,strong) PFObject *tag;

@end
