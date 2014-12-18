//
//  DVAVerticalPageViewController.h
//  NestedPageViewController
//
//  Created by Miguel Ferrando on 02/12/13.
//  Copyright (c) 2013 Develapps. All rights reserved.
//

@class DVANestedPageViewController;

@interface DVAVerticalPageViewController : UIViewController

@property (nonatomic, strong) NSIndexPath *indexPath;

- (instancetype)initWithHorizontal:(DVANestedPageViewController *)horizontal;

@end
