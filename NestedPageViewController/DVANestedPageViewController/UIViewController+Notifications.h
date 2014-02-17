//
//  UIViewController+Notifications.h
//  NestedPageViewController
//
//  Created by Miguel Ferrando on 10/02/14.
//  Copyright (c) 2014 Develapps. All rights reserved.
//

@interface UIViewController (Notifications)

+ (NSString *)dva_viewControllerWillAppearNotificationName;
+ (NSString *)dva_viewControllerDidAppearNotificationName;
+ (NSString *)dva_viewControllerWillDisappearNotificationName;
+ (NSString *)dva_viewControllerDidDisappearNotificationName;

- (void)dva_swizzled_viewWillAppear:(BOOL)animated;
- (void)dva_swizzled_viewDidAppear:(BOOL)animated;
- (void)dva_swizzled_viewWillDisappear:(BOOL)animated;
- (void)dva_swizzled_viewDidDisappear:(BOOL)animated;

@end
