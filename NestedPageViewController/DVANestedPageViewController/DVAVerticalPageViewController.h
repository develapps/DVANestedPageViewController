//
//  DVAVerticalPageViewController.h
//  NestedPageViewController
//
//  Created by Miguel Ferrando on 02/12/13.
//  Copyright (c) 2013 Develapps. All rights reserved.
//

@class DVAVerticalPageViewController;

@protocol DVAVerticalPageViewControllerDataSource <NSObject>

- (NSUInteger)verticalPageViewControllerNumberOfViewControllers:(DVAVerticalPageViewController *)verticalPageViewController;
- (UIViewController *)verticalPageViewController:(DVAVerticalPageViewController *)verticalPageViewController viewControllerAtIndex:(NSUInteger)index;

@end

@interface DVAVerticalPageViewController : UIViewController

@property (nonatomic, weak) id<DVAVerticalPageViewControllerDataSource> dataSource;
@property (nonatomic) NSUInteger section;

@end
