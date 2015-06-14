//
//  WINUser.m
//  WinWin
//
//  Created by Othonas Antoniou on 6/13/15.
//  Copyright (c) 2015 GENERiO. All rights reserved.
//

#import "WINUser.h"

@interface WINUser () <NSCoding>

@end

@implementation WINUser

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _ID = [aDecoder decodeObjectForKey:@"WINUser.ID"];
        _vat = [aDecoder decodeObjectForKey:@"WINUser.vat"];
        _cardID = [aDecoder decodeObjectForKey:@"WINUser.cardID"];
        _name = [aDecoder decodeObjectForKey:@"WINUser.name"];
        _isSeller = [aDecoder decodeBoolForKey:@"WINUser.isSeller"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ID forKey:@"WINUser.ID"];
    [aCoder encodeObject:self.vat forKey:@"WINUser.vat"];
    [aCoder encodeObject:self.cardID forKey:@"WINUser.cardID"];
    [aCoder encodeObject:self.name forKey:@"WINUser.name"];
    [aCoder encodeBool:self.isSeller forKey:@"WINUser.isSeller"];
}

@end
