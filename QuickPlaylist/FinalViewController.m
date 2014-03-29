//
//  FinalViewController.m
//  QuickPlaylist
//
//  Created by Kelby on 3/28/14.
//  Copyright (c) 2014 Kelby Green. All rights reserved.
//

#import "FinalViewController.h"

@interface FinalViewController ()

@end

@implementation FinalViewController

@synthesize ibTextField;

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [ibTextField performSelectorOnMainThread:@selector(becomeFirstResponder) withObject:nil waitUntilDone:NO];
}

- (IBAction)ibaSavePressed:(id)sender {
}
@end
