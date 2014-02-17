//
//  DVAVerticalPageViewController.m
//  NestedPageViewController
//
//  Created by Miguel Ferrando on 02/12/13.
//  Copyright (c) 2013 Develapps. All rights reserved.
//

#import "DVAVerticalPageViewController.h"
#import "DVANestedPageViewController.h"
#import <objc/runtime.h>

@interface DVAVerticalPageViewController () <UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSNumber *rows;

@end

@implementation DVAVerticalPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addChildViewController:self.pageViewController];
    [self.pageViewController didMoveToParentViewController:self];
    [self.view addSubview:self.pageViewController.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (UIPageViewController *)pageViewController
{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationVertical options:nil];
        _pageViewController.dataSource = self;
    }
    
    return _pageViewController;
}

- (NSNumber *)rows
{
    if (!_rows) {
        _rows = @([self.dataSource verticalPageViewControllerNumberOfViewControllers:self]);
    }
    
    return _rows;
}


#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSIndexPath *indexPathBefore = objc_getAssociatedObject(viewController, DVANestedPageViewControllerPositionKey);
    NSUInteger index = indexPathBefore.row;
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSIndexPath *indexPathAfter = objc_getAssociatedObject(viewController, DVANestedPageViewControllerPositionKey);
    NSUInteger index = indexPathAfter.row;
    
    index++;
    if (index == [self.rows unsignedIntegerValue]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    NSUInteger numberOfViewControllers = [self.dataSource verticalPageViewControllerNumberOfViewControllers:self];
    
    if (numberOfViewControllers == 0) {
        return nil;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:self.section];
    UIViewController *viewController = [self.dataSource verticalPageViewController:self viewControllerAtIndex:index];
    
    // set position via associated object
    objc_setAssociatedObject(viewController, DVANestedPageViewControllerPositionKey, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return viewController;
}

@end
