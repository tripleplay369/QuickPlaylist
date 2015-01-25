//
//  HelpViewController.m
//  QuickPlaylist
//
//  Created by Kelby on 3/28/14.
//  Copyright (c) 2014 Kelby Green. All rights reserved.
//

#import "HelpViewController.h"

#import "HelpCell.h"
#import "MediaManager.h"

@interface HelpViewController()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *ibTable;
@property UISwitch * toggle;

@end

@implementation HelpViewController

@synthesize ibTable;
@synthesize toggle;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    ibTable.delegate = self;
    ibTable.dataSource = self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)return 5;
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    HelpCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[HelpCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
    }
    
    int section = [indexPath indexAtPosition:0];
    int row = [indexPath indexAtPosition:1];
    
    if(section == 1){
        cell.textLabel.text = @"Show iCloud Music";
        toggle = [[UISwitch alloc] initWithFrame:CGRectZero];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        toggle.on = [[defaults objectForKey:@"iCloud"] boolValue] == YES;
        [toggle addTarget:self action:@selector(switched) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = toggle;
        UIImage * image = [UIImage imageNamed:@"cloudstorage.png"];
        cell.imageView.image = image;
    }
    else{
        if(row == 0){
            cell.textLabel.text = @"Move between steps";
            UIImage * image = [UIImage imageNamed:@"swipe.png"];
            cell.imageView.image = image;
        }
        else if(row == 1){
            cell.textLabel.text = @"Add song to the playlist";
            UIImage * image = [UIImage imageNamed:@"tap.png"];
            cell.imageView.image = image;
        }
        else if(row == 2){
            cell.textLabel.text = @"Refresh random songs";
            UIImage * image = [UIImage imageNamed:@"down.png"];
            cell.imageView.image = image;
        }
        else if(row == 3){
            cell.textLabel.text = @"Reorder song in playlist";
            UIImage * image = [UIImage imageNamed:@"drag.png"];
            cell.imageView.image = image;
            cell.smallIcon = YES;
        }
        else if(row == 4){
            cell.textLabel.text = @"Delete song from playlist";
            UIImage * image = [UIImage imageNamed:@"delete.png"];
            cell.imageView.image = image;
            cell.smallIcon = YES;
        }
    }
    
    return cell;
}

-(void)switched
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(toggle.on) forKey:@"iCloud"];
    [defaults synchronize];
    [[MediaManager shared] refreshSongs];
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
