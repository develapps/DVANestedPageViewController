//
//  DVANestedPageViewController.h
//  NestedPageViewController
//
//  Created by Miguel Ferrando on 28/11/13.
//  Copyright (c) 2013 Develapps. All rights reserved.
//

@class DVANestedPageViewController;

extern const void *DVANestedPageViewControllerPositionKey;

@protocol DVANestedPageViewControllerDataSource <NSObject>

- (NSUInteger)nestedPageViewController:(DVANestedPageViewController *)nestedPageViewController numberOfViewControllersAtSection:(NSUInteger)section;
- (UIViewController *)nestedPageViewController:(DVANestedPageViewController *)nestedPageViewController viewControllerAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSUInteger)nestedPageViewControllerNumberOfSections:(DVANestedPageViewController *)nestedPageViewController; // 1 by default

@end

@protocol DVANestedPageViewControllerDelegate <NSObject>

@optional
- (void)nestedPageViewController:(DVANestedPageViewController *)nestedPageViewController viewControllerWillAppear:(UIViewController *)viewController atIndexPath:(NSIndexPath *)indexPath;
- (void)nestedPageViewController:(DVANestedPageViewController *)nestedPageViewController viewControllerDidAppear:(UIViewController *)viewController atIndexPath:(NSIndexPath *)indexPath;
- (void)nestedPageViewController:(DVANestedPageViewController *)nestedPageViewController viewControllerWillDisappear:(UIViewController *)viewController atIndexPath:(NSIndexPath *)indexPath;
- (void)nestedPageViewController:(DVANestedPageViewController *)nestedPageViewController viewControllerDidDisappear:(UIViewController *)viewController atIndexPath:(NSIndexPath *)indexPath;

@end

@interface DVANestedPageViewController : UIViewController

@property (nonatomic, strong, readonly) NSIndexPath *currentIndexPath;
@property (nonatomic, weak) IBOutlet id<DVANestedPageViewControllerDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id<DVANestedPageViewControllerDelegate> delegate;

- (void)reloadData;
- (void)scrollToIndexPath:(NSIndexPath *)indexPath;

@end
