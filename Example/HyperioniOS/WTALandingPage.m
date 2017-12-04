//
//  WTAViewController.m
//  HyperioniOS
//
//  Created by chrsmys on 05/04/2017.
//  Copyright (c) 2017 chrsmys. All rights reserved.
//

#import "WTALandingPage.h"
#import "WTAPageControl.h"
#import <HyperioniOS/HyperionManager.h>
#import <HyperioniOS/HYPPlugin.h>
@import AVFoundation;
@import AVKit;

@interface WTALandingPage () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (weak, nonatomic) IBOutlet WTAPageControl *pageControl;
@property (retain) UIPageViewController *pageViewController;

@end

@implementation WTALandingPage
{
    NSInteger currentIndex;
    NSInteger pendingIndex;
    NSMutableArray *pages;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    pages = [NSMutableArray new];
    [self setupPages];

    self.pageControl.numberOfPages = pages.count;
    [self.view bringSubviewToFront:self.pageControl];
}

- (void)setupPages
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:[NSBundle bundleForClass:[self class]]];

    UIViewController *welcomeViewController = [storyboard instantiateViewControllerWithIdentifier:@"welcome"];
    UIViewController *gesturesViewController = [storyboard instantiateViewControllerWithIdentifier:@"gestures"];
    [pages addObjectsFromArray:@[welcomeViewController, gesturesViewController]];

    NSArray<Class<HYPPlugin>> *plugins = [[HyperionManager sharedInstance] retrievePluginClasses];

    for (Class<HYPPlugin> plugin in plugins)
    {
        if (![plugin respondsToSelector:@selector(createPluginGuideViewController)]) {
            continue;
        }
        
        UIViewController *pluginViewController = [plugin performSelector:@selector(createPluginGuideViewController)];
        if (pluginViewController)
        {
            [pages addObject:pluginViewController];
        }
    }

    self.pageViewController = [[UIPageViewController alloc]
                               initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                               options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    [self.pageViewController setViewControllers:@[welcomeViewController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:^(BOOL finished) {}];

    [self.view addSubview:self.pageViewController.view];
}


#pragma UIPageViewControllerDataSource

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerBeforeViewController:(nonnull UIViewController *)viewController
{
    NSInteger currentIndex = [pages indexOfObject:viewController];
    if (currentIndex == 0 || currentIndex == NSNotFound)
    {
        return nil;
    }

    NSInteger previousIndex = (currentIndex - 1) % pages.count;
    return pages[previousIndex];
}

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerAfterViewController:(nonnull UIViewController *)viewController
{
     NSInteger currentIndex = [pages indexOfObject:viewController];
    if (currentIndex == pages.count - 1)
    {
        return nil;
    }

    NSInteger nextIndex = (currentIndex + 1) % pages.count;
    return pages[nextIndex];
}

#pragma UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    pendingIndex = [pages indexOfObject:pendingViewControllers.firstObject];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed)
    {
        currentIndex = pendingIndex;
        self.pageControl.currentPage = currentIndex;
    }
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    // Hide the default UIPageControl.
    return 0;
}

@end
