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

@property UIViewController * pendingViewController;
@property NSInteger pageIndex;

@end

@implementation PageViewController

@synthesize pendingViewController;
@synthesize pageIndex;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setViewControllers:@[[self.storyboard instantiateViewControllerWithIdentifier:@"help"]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.dataSource = self;
    self.delegate = self;
    
    pageIndex = 0;
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
    if([viewController isKindOfClass:[TableViewController class]]){
        return [self.storyboard instantiateViewControllerWithIdentifier:@"help"];
    }
    else if([viewController isKindOfClass:[PlaylistTableViewController class]]){
        return [self.storyboard instantiateViewControllerWithIdentifier:@"table"];
    }
    else if([viewController isKindOfClass:[FinalViewController class]]){
        return [self.storyboard instantiateViewControllerWithIdentifier:@"playlist"];
    }
    return nil;
    
}

-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    pendingViewController = [pendingViewControllers objectAtIndex:0];
}

-(void)reset
{
    [self setViewControllers:@[[self.storyboard instantiateViewControllerWithIdentifier:@"table"]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(!completed) return;
    
    if([pendingViewController isKindOfClass:[TableViewController class]] && [[previousViewControllers objectAtIndex:0] isKindOfClass:[FinalViewController class]]){
        [self performSelectorOnMainThread:@selector(reset) withObject:nil waitUntilDone:NO];
        [[MediaManager shared] clearPlaylist];
    }
    
    if([[previousViewControllers objectAtIndex:0] isKindOfClass:[FinalViewController class]]){
        FinalViewController * fvc = [previousViewControllers objectAtIndex:0];
        [fvc stop];
    }
    
    if([pendingViewController isKindOfClass:[HelpViewController class]]){
        pageIndex = 0;
    }
    else if([pendingViewController isKindOfClass:[TableViewController class]]){
        pageIndex = 1;
    }
    else if([pendingViewController isKindOfClass:[PlaylistTableViewController class]]){
        pageIndex = 2;
    }
    else if([pendingViewController isKindOfClass:[FinalViewController class]]){
        pageIndex = 3;
    }
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 4;
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return pageIndex;
}

-(UIViewController *)currentViewController
{
    return [self.viewControllers objectAtIndex:0];
}

@end
