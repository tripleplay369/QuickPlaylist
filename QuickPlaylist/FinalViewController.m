//
//  FinalViewController.m
//  QuickPlaylist
//
//  Created by Kelby on 3/28/14.
//  Copyright (c) 2014 Kelby Green. All rights reserved.
//

#import "FinalViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "MediaManager.h"

@interface FinalViewController ()

@property (weak, nonatomic) IBOutlet UIImageView * ibImageView;

@end

@implementation FinalViewController

@synthesize ibImageView;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer * singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(play:)];
    [ibImageView addGestureRecognizer:singleFingerTap];
}

-(void)play:(UITapGestureRecognizer *)recognizer
{
    NSArray * playlist = [[MediaManager shared] getPlaylist];
    
    if(playlist.count == 0) return;
    
    MPMusicPlayerController * player = [MPMusicPlayerController iPodMusicPlayer];
    [player setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:playlist]];
    [player setNowPlayingItem:playlist[0]];
    [player prepareToPlay];
    [player play];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"music://"]];
}

-(void)viewWillLayoutSubviews{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        self.view.clipsToBounds = YES;
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenHeight = 0.0;
        if(UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
            screenHeight = screenRect.size.height;
        else
            screenHeight = screenRect.size.width;
        CGRect screenFrame = CGRectMake(0, 20, self.view.frame.size.width,screenHeight-20);
        CGRect viewFr = [self.view convertRect:self.view.frame toView:nil];
        if (!CGRectEqualToRect(screenFrame, viewFr))
        {
            self.view.frame = screenFrame;
            self.view.bounds = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }
    }
}

@end
