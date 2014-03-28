//
//  PageViewController.m
//  QuickPlaylist
//
//  Created by Kelby on 3/28/14.
//  Copyright (c) 2014 Kelby Green. All rights reserved.
//

#import "PageViewController.h"
#import "HelpViewController.h"
#import "TableViewController.h"
#import "PlaylistTableViewController.h"
#import "FinalViewController.h"
#import "MediaManager.h"

@interface PageViewController()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@end

@implementation PageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setViewControllers:@[[self.storyboard instantiateViewControllerWithIdentifier:@"help"]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.dataSource = self;
    self.delegate = self;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if([viewController isKindOfClass:[HelpViewController class]]){
        return [self.storyboard instantiateViewControllerWithIdentifier:@"table"];
    }
    else if([viewController isKindOfClass:[TableViewController class]]){
        return [self.storyboard instantiateViewControllerWithIdentifier:@"playlist"];
    }
    else if([viewController isKindOfClass:[PlaylistTableViewController class]]){
        return [self.storyboard instantiateViewControllerWithIdentifier:@"final"];
    }
    else if([viewController isKindOfClass:[FinalViewController class]]){
        return [self.storyboard instantiateViewControllerWithIdentifier:@"table"];
    }
    return nil;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if([viewController isKindOfClass:[PlaylistTableViewController class]]){
        return [self.storyboard instantiateViewControllerWithIdentifier:@"table"];
    }
    else if([viewController isKindOfClass:[FinalViewController class]]){
        return [self.storyboard instantiateViewControllerWithIdentifier:@"playlist"];
    }
    return nil;
    
}

-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    ;
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    ;
}

@end
