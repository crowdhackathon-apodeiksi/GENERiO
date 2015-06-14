//
//  UITextFieldHelper.m
//  WinWIn
//
//  Created by Othonas Antoniou on 6/13/15.
//  Copyright (c) 2015 GENERiO. All rights reserved.
//

#import "UITextFieldHelper.h"

@implementation UITextFieldHelper

+ (UIView *)toolBarInputAccessorryViewWithTarget:(id)target previous:(SEL)previousSelector next:(SEL)nextSelector done:(SEL)doneSelector
{
    UIBarButtonItem *barBtnPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:target action:previousSelector];
    UIBarButtonItem *barBtnNext = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:target action:nextSelector];
    UIBarButtonItem *barBtnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *barBtnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:target action:doneSelector];
    
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName: [UIColor orangeColor],
                                 NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0]
                                 };
    
    barBtnPrevious.tintColor = [UIColor whiteColor];
    [barBtnPrevious setTitleTextAttributes:attributes forState:UIControlStateNormal];
    barBtnNext.tintColor = [UIColor whiteColor];
    [barBtnNext setTitleTextAttributes:attributes forState:UIControlStateNormal];
    barBtnDone.tintColor = [UIColor whiteColor];
    [barBtnDone setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    [toolBar setBarStyle:UIBarStyleBlackTranslucent];
    [toolBar sizeToFit];
    [toolBar setItems:@[barBtnPrevious, barBtnNext, barBtnSpace, barBtnDone]];
    return toolBar;
}

+ (UIView *)toolBarInputAccessorryViewWithTarget:(id)target segmentedSelector:(SEL)selectorSegmented doneSelector:(SEL)doneSelector
{
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Previous", @"Next", nil]];
    segmentedControl.momentary = YES;
    segmentedControl.tintColor = [UIColor orangeColor];
    [segmentedControl addTarget:target action:selectorSegmented forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *barBtnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    barBtnSpace.tintColor = [UIColor orangeColor];
    UIBarButtonItem *barBtnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:target action:doneSelector];
    barBtnDone.tintColor = [UIColor orangeColor];
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    [toolBar setBarStyle:UIBarStyleBlackTranslucent];
    [toolBar sizeToFit];
    [toolBar setItems:[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithCustomView:segmentedControl], barBtnSpace, barBtnDone, nil]];
    return toolBar;
}

@end
