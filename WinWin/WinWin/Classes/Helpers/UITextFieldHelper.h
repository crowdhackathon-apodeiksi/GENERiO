//
//  UITextFieldHelper.h
//  WinWin
//
//  Created by Othonas Antoniou on 6/13/15.
//  Copyright (c) 2015 GENERiO. All rights reserved.
//

@import Foundation;

@interface UITextFieldHelper : NSObject

+ (UIView *)toolBarInputAccessorryViewWithTarget:(id)target previous:(SEL)previousSelector next:(SEL)nextSelector done:(SEL)doneSelector;
+ (UIView *)toolBarInputAccessorryViewWithTarget:(id)target segmentedSelector:(SEL)selectorSegmented doneSelector:(SEL)doneSelector;

@end
