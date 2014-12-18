//
//  DVAViewController.m
//  NestedPageViewController
//
//  Created by Miguel Ferrando on 07/02/14.
//  Copyright (c) 2014 Develapps. All rights reserved.
//

#import "DVAViewController.h"
#import "DVANestedPageViewController.h"

@interface DVAViewController () <DVANestedPageViewControllerDataSource, DVANestedPageViewControllerDelegate>

@property (nonatomic, strong) DVANestedPageViewController *nestedPageVC;
@property (nonatomic, strong) NSDictionary *model;
@property (nonatomic, strong) NSDictionary *colors;

@end

@implementation DVAViewController

- (NSDictionary *)model
{
    if (!_model) {
        _model = @{@(0): @(1),
                   @(1): @(2),
                   @(2): @(3)};
    }
    
    return _model;
}

- (NSDictionary *)colors
{
    if (!_colors) {
        _colors = @{@"00": [UIColor redColor],
                    @"10": [UIColor yellowColor],
                    @"11": [UIColor orangeColor],
                    @"20": [UIColor greenColor],
                    @"21": [UIColor purpleColor],
                    @"22": [UIColor brownColor]};
    }
    
    return _colors;
}

- (void)setNestedPageVC:(DVANestedPageViewController *)nestedPageVC
{
    _nestedPageVC = nestedPageVC;
    _nestedPageVC.dataSource = self;
    _nestedPageVC.delegate = self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // this is called automatically, we asignate our reference to the container here
    if ([segue.identifier isEqualToString:@"embed"]) {
        self.nestedPageVC = segue.destinationViewController;
    }
}

#pragma mark - DVANestedPageViewControllerDataSource

- (NSUInteger)nestedPageViewControllerNumberOfSections:(DVANestedPageViewController *)nestedPageViewController
{
    return self.model.allKeys.count;
}

- (NSUInteger)nestedPageViewController:(DVANestedPageViewController *)nestedPageViewController numberOfViewControllersAtSection:(NSUInteger)section
{
    return [self.model[@(section)] unsignedIntegerValue];
}

- (UIViewController *)nestedPageViewController:(DVANestedPageViewController *)nestedPageViewController viewControllerAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view.backgroundColor = self.colors[[NSString stringWithFormat:@"%ld%ld", (long)indexPath.section, (long)indexPath.row]];
    
    return viewController;
}

#pragma mark - DVANestedPageViewControllerDelegate

- (void)nestedPageViewController:(DVANestedPageViewController *)nestedPageViewController viewControllerWillAppear:(UIViewController *)viewController atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s section: %ld  row: %ld", __PRETTY_FUNCTION__, (long)indexPath.section, (long)indexPath.row);
}

- (void)nestedPageViewController:(DVANestedPageViewController *)nestedPageViewController viewControllerDidAppear:(UIViewController *)viewController atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s section: %ld  row: %ld", __PRETTY_FUNCTION__, (long)indexPath.section, (long)indexPath.row);
}

- (void)nestedPageViewController:(DVANestedPageViewController *)nestedPageViewController viewControllerWillDisappear:(UIViewController *)viewController atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s section: %ld  row: %ld", __PRETTY_FUNCTION__, (long)indexPath.section, (long)indexPath.row);
}

- (void)nestedPageViewController:(DVANestedPageViewController *)nestedPageViewController viewControllerDidDisappear:(UIViewController *)viewController atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s section: %ld  row: %ld", __PRETTY_FUNCTION__, (long)indexPath.section, (long)indexPath.row);
}

@end
