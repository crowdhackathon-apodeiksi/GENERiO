//
//  UIImage+Extensions.h
//  WinWin
//
//  Created by Othonas Antoniou on 6/13/15.
//  Copyright (c) 2015 GENERiO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extensions)

+ (UIImage *)imageWithImage:(UIImage *)image overlayColor:(UIColor *)color;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
