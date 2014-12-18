//
//  DVANestedPageViewController.m
//  NestedPageViewController
//
//  Created by Miguel Ferrando on 28/11/13.
//  Copyright (c) 2013 Develapps. All rights reserved.
//

#import "DVANestedPageViewController.h"
#import "DVAVerticalPageViewController.h"
#import "UIViewController+Notifications.h"
#import <objc/runtime.h>

const void *DVANestedPageViewControllerPositionKey = &DVANestedPageViewControllerPositionKey;

@interface DVANestedPageViewController () <UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong, readwrite) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSNumber *sections;
@property (nonatomic) NSUInteger *section;

@end

@implementation DVANestedPageViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self addObservers];
    [self setupView];
    [self loadViewControllers];
}

- (void)dealloc
{
    [self removeObservers];
}

- (UIPageViewController *)pageViewController
{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.dataSource = self;
    }
    
    return _pageViewController;
}

- (NSNumber *)sections
{
    if (!_sections) {
        _sections = @([self.dataSource respondsToSelector:@selector(nestedPageViewControllerNumberOfSections:)] ? [self.dataSource nestedPageViewControllerNumberOfSections:self] : 1);
    }
    
    return _sections;
}

- (void)addObservers
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(viewControllerWillAppear:) name:[UIViewController dva_viewControllerWillAppearNotificationName] object:nil];
    [center addObserver:self selector:@selector(viewControllerDidAppear:) name:[UIViewController dva_viewControllerDidAppearNotificationName] object:nil];
    [center addObserver:self selector:@selector(viewControllerWillDisappear:) name:[UIViewController dva_viewControllerWillDisappearNotificationName] object:nil];
    [center addObserver:self selector:@selector(viewControllerDidDisappear:) name:[UIViewController dva_viewControllerDidDisappearNotificationName] object:nil];
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupView
{
    [self addChildViewController:self.pageViewController];
    [self.pageViewController didMoveToParentViewController:self];
    [self.view addSubview:self.pageViewController.view];
}

- (void)reloadData
{
    [self loadViewControllers];
}

- (void)loadViewControllers
{
    if ([self.sections unsignedIntegerValue] > 0) {
        NSUInteger initialSectionNumber = 0;

        if (self.initialPosition > 0 && self.initialPosition <= [self.sections unsignedIntegerValue]) {
            initialSectionNumber = self.initialPosition;
            self.initialPosition = -1;
        }

        NSArray *viewControllers = @[[self viewControllerAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:initialSectionNumber]]];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
}

- (UIViewController *)viewControllerAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger viewControllersPerSection = [self.dataSource nestedPageViewController:self numberOfViewControllersAtSection:indexPath.section];
    
    if (viewControllersPerSection == 0) [[NSException exceptionWithName:@"Invalid parameter" reason:@"Section cannot be empty" userInfo:nil] raise];
    
    if (viewControllersPerSection == 1) {
        // we can handle without involving vertical scroll
        UIViewController *viewController = [self.dataSource nestedPageViewController:self viewControllerAtIndexPath:indexPath];
        
        // set position via associated object
        objc_setAssociatedObject(viewController, DVANestedPageViewControllerPositionKey, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        return viewController;
    }
    else { //  viewControllersPerSection > 1, need vertical scroll
        DVAVerticalPageViewController *verticalPageVC = [[DVAVerticalPageViewController alloc] initWithHorizontal:self];
        verticalPageVC.indexPath = indexPath;
        
        return verticalPageVC;
    }    
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSIndexPath *indexPathBefore = [self indexPathForViewController:viewController];
    NSUInteger section = indexPathBefore.section;

    if (section == 0) return nil;
    
    section--;
    return [self viewControllerAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSIndexPath *indexPathAfter = [self indexPathForViewController:viewController];
    NSUInteger section = indexPathAfter.section;

    section++;
    if (section == [self.sections unsignedIntegerValue]) {
        return nil;
    }

    return [self viewControllerAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
}

- (NSIndexPath *)indexPathForViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[DVAVerticalPageViewController class]]) {
        DVAVerticalPageViewController *verticalPageVC = (DVAVerticalPageViewController *)viewController;
        // we don't care about the depth
        return verticalPageVC.indexPath;
    }
    else {
        return objc_getAssociatedObject(viewController, DVANestedPageViewControllerPositionKey);
    }
}

- (void)scrollToIndexPath:(NSIndexPath *)indexPath
{
    // we do this setting the direction in reverse order to force asking again for viewController before and after
    self.pageViewController.view.alpha = 0;
    NSUInteger section = indexPath.section;
    [self.pageViewController setViewControllers:@[[self viewControllerAtIndexPath:indexPath]]
                                      direction:(self.currentIndexPath.section < section) ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.pageViewController.view.alpha = 1;
                     }];
}

- (void)slideLeftAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    NSInteger slideToSection = self.currentIndexPath.section - 1;

    if (slideToSection < 0) return completion ? completion(NO) : nil;

    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:self.currentIndexPath.row inSection:slideToSection];

    [self.pageViewController setViewControllers:@[[self viewControllerAtIndexPath:newIndexPath]]
                                      direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:animated
                                     completion:completion];
}

- (void)slideRightAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    NSInteger slideToSection = self.currentIndexPath.section + 1;
    NSInteger numberOfSections = [self.sections integerValue];

    if (slideToSection >= numberOfSections) return completion ? completion(NO) : nil;

    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:self.currentIndexPath.row inSection:slideToSection];

    [self.pageViewController setViewControllers:@[[self viewControllerAtIndexPath:newIndexPath]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:animated
                                     completion:completion];
}

#pragma mark - Notifications

// we check the indexPath value in order to know if it is an instance of a class we are interested on
- (void)viewControllerWillAppear:(NSNotification *)notification
{
    UIViewController *viewController = notification.object;
    NSIndexPath *indexPath = objc_getAssociatedObject(viewController, DVANestedPageViewControllerPositionKey);
    
    if (!indexPath || ![self.delegate respondsToSelector:@selector(nestedPageViewController:viewControllerWillAppear:atIndexPath:)]) return;
    
    [self.delegate nestedPageViewController:self viewControllerWillAppear:viewController atIndexPath:indexPath];
}

- (void)viewControllerDidAppear:(NSNotification *)notification
{
    UIViewController *viewController = notification.object;
    NSIndexPath *indexPath = objc_getAssociatedObject(viewController, DVANestedPageViewControllerPositionKey);
    
    if (!indexPath) return;
    
    self.currentIndexPath = indexPath;
    
    if (![self.delegate respondsToSelector:@selector(nestedPageViewController:viewControllerDidAppear:atIndexPath:)]) return;
    
    [self.delegate nestedPageViewController:self viewControllerDidAppear:viewController atIndexPath:indexPath];
}

- (void)viewControllerWillDisappear:(NSNotification *)notification
{
    UIViewController *viewController = notification.object;
    NSIndexPath *indexPath = objc_getAssociatedObject(viewController, DVANestedPageViewControllerPositionKey);
    
    if (!indexPath || ![self.delegate respondsToSelector:@selector(nestedPageViewController:viewControllerWillDisappear:atIndexPath:)]) return;
    
    [self.delegate nestedPageViewController:self viewControllerWillDisappear:viewController atIndexPath:indexPath];
}

- (void)viewControllerDidDisappear:(NSNotification *)notification
{
    UIViewController *viewController = notification.object;
    NSIndexPath *indexPath = objc_getAssociatedObject(viewController, DVANestedPageViewControllerPositionKey);
    
    if (!indexPath || ![self.delegate respondsToSelector:@selector(nestedPageViewController:viewControllerDidDisappear:atIndexPath:)]) return;
    
    [self.delegate nestedPageViewController:self viewControllerDidDisappear:viewController atIndexPath:indexPath];
}

@end
