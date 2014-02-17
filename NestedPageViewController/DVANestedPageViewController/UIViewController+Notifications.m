//
//  UIViewController+Notifications.m
//  NestedPageViewController
//
//  Created by Miguel Ferrando on 10/02/14.
//  Copyright (c) 2014 Develapps. All rights reserved.
//

#import "UIViewController+Notifications.h"
#import <objc/runtime.h>

@implementation UIViewController (Notifications)

+ (NSString *)dva_viewControllerWillAppearNotificationName
{
    return @"dva_viewWillAppearNotificationName";
}

+ (NSString *)dva_viewControllerDidAppearNotificationName
{
    return @"dva_viewDidAppearNotificationName";
}

+ (NSString *)dva_viewControllerWillDisappearNotificationName
{
    return @"dva_viewWillDisappearNotificationName";
}

+ (NSString *)dva_viewControllerDidDisappearNotificationName
{
    return @"dva_viewDidDisappearNotificationName";
}

- (void)dva_swizzled_viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:[UIViewController dva_viewControllerWillAppearNotificationName] object:self];
    
    [self dva_swizzled_viewWillAppear:animated];
}

- (void)dva_swizzled_viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:[UIViewController dva_viewControllerDidAppearNotificationName] object:self];
    
    [self dva_swizzled_viewDidAppear:animated];
}

- (void)dva_swizzled_viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:[UIViewController dva_viewControllerWillDisappearNotificationName] object:self];
    
    [self dva_swizzled_viewWillDisappear:animated];
}

- (void)dva_swizzled_viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:[UIViewController dva_viewControllerDidDisappearNotificationName] object:self];
    
    [self dva_swizzled_viewDidDisappear:animated];
}

@end
