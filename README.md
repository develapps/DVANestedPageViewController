# DVANestedPageViewController
DVANestedPageViewController is a clean and easy-to-use wrapper around UIPageViewController

## Features
* Supports nested UIPageViewController letting you to scroll in both directions
* UITableView-like data source 
* Delegate letting you know when view controllers will/did appear and will/did dissapear


## Installation
### As a [CocoaPod](http://cocoapods.org/)
Just add this to your Podfile
```ruby
pod 'DVANestedPageViewController'
```

### Other approaches
* Add `DVANestedPageViewController.h/m`, `DVAVerticalPageViewController.h/m` and `UIViewController+Notifications.h/m` to your project.

## Usage

(see sample Xcode project using storyboard in `/NestedPageViewController`)

Add a DVANestedPageViewController instance as a container view controller (by code or storyboard) and implement the following methods for the dataSource and delegate:

```objective-c
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
```

## Credits

DVANestedPageViewController is brought to you by [Miguel Ferrando](http://mfnavalon.com). Contributions are more than welcome. If you're using DVANestedPageViewController in your project, let me know!.