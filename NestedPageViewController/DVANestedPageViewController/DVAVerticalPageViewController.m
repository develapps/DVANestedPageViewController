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
@property (nonatomic, weak) DVANestedPageViewController *horizontal;

@end

@implementation DVAVerticalPageViewController

- (instancetype)initWithHorizontal:(DVANestedPageViewController *)horizontal
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _horizontal = horizontal;
    }
    
    return self;
}

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
    
    UIViewController *startingViewController = [self viewControllerForRow:self.indexPath.row];
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
        _rows = @([self.horizontal.dataSource nestedPageViewControllerNumberOfSections:self.horizontal]);
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
    return [self viewControllerForRow:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSIndexPath *indexPathAfter = objc_getAssociatedObject(viewController, DVANestedPageViewControllerPositionKey);
    NSUInteger index = indexPathAfter.row;
    
    index++;
    if (index == [self.rows unsignedIntegerValue]) return nil;
    
    return [self viewControllerForRow:index];
}

- (UIViewController *)viewControllerForRow:(NSUInteger)row
{    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:self.indexPath.section];
    UIViewController *viewController = [self.horizontal.dataSource nestedPageViewController:self.horizontal viewControllerAtIndexPath:indexPath];
    
    // set position via associated object
    objc_setAssociatedObject(viewController, DVANestedPageViewControllerPositionKey, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return viewController;
}

@end
