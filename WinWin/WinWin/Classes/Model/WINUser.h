//
//  WINUser.h
//  WinWin
//
//  Created by Othonas Antoniou on 6/13/15.
//  Copyright (c) 2015 GENERiO. All rights reserved.
//

@import Foundation;

@interface WINUser : NSObject

@property(nonatomic,strong) NSString *ID;
@property(nonatomic,strong) NSNumber *vat;
@property(nonatomic,strong) NSNumber *cardID;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,assign) BOOL isSeller;

@end
