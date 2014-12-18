//
//  NestedPageViewControllerTests.m
//  NestedPageViewControllerTests
//
//  Created by Miguel Ferrando on 07/02/14.
//  Copyright (c) 2014 Develapps. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock.h>
#import "DVANestedPageViewController.h"

@interface NestedPageViewControllerTests : XCTestCase {
    DVANestedPageViewController *nestedPageViewController;
    id dataSource;
    UIViewController *foo;
}

@end

@implementation NestedPageViewControllerTests

- (void)setUp
{
    [super setUp];

    nestedPageViewController = [DVANestedPageViewController new];
    dataSource = OCMProtocolMock(@protocol(DVANestedPageViewControllerDataSource));
    nestedPageViewController.dataSource = dataSource;
    foo = [[UIViewController alloc] init];
}

- (void)tearDown
{
    dataSource = nil;
    nestedPageViewController = nil;
    foo = nil;
    
    [super tearDown];
}

- (void)testThatScrollToIndexPathWorksForJustSections
{
    OCMExpect([dataSource nestedPageViewController:nestedPageViewController numberOfViewControllersAtSection:1]).andReturn((NSUInteger)1);
    OCMExpect([dataSource nestedPageViewController:nestedPageViewController viewControllerAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]]).andReturn(foo);
    
    [nestedPageViewController viewDidLoad];
    NSIndexPath *movedIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [nestedPageViewController scrollToIndexPath:movedIndexPath];
    NSIndexPath *returnedIndexPath = [nestedPageViewController currentIndexPath];
    
    XCTAssertEqualObjects(movedIndexPath, returnedIndexPath, @"NSIndexPath's must be the same");
    OCMVerifyAll(dataSource);
}

- (void)testThatScrollToIndexPathWorksAlsoForRows
{
    OCMExpect([dataSource nestedPageViewController:nestedPageViewController numberOfViewControllersAtSection:1]).andReturn((NSUInteger)4);
    OCMExpect([dataSource nestedPageViewController:nestedPageViewController viewControllerAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]]).andReturn(foo);
    
    [nestedPageViewController viewDidLoad];
    NSIndexPath *movedIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    [nestedPageViewController scrollToIndexPath:movedIndexPath];
    NSIndexPath *returnedIndexPath = [nestedPageViewController currentIndexPath];

    OCMVerifyAll(dataSource);
    XCTAssertEqualObjects(movedIndexPath, returnedIndexPath, @"NSIndexPath's must be the same");
}

- (void)testThatScrollToUnexistingIndexPathCrashes
{
    [nestedPageViewController viewDidLoad];
    NSIndexPath *movedIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];

    XCTAssertThrows([nestedPageViewController scrollToIndexPath:movedIndexPath], @"Exception must be raised when scrolling to an unexisting indexPath");
}

@end
