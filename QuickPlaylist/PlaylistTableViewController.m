//
//  PlaylistTableViewController.m
//  QuickPlaylist
//
//  Created by Kelby on 3/28/14.
//  Copyright (c) 2014 Kelby Green. All rights reserved.
//

#import "PlaylistTableViewController.h"
#import "MediaManager.h"

@interface PlaylistTableViewController()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation PlaylistTableViewController

@synthesize ibTable;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    ibTable.dataSource = self;
    ibTable.delegate = self;
    ibTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [ibTable setEditing:YES animated:NO];
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

-(void)viewDidAppear:(BOOL)animated
{
    [ibTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
    }
    
    MPMediaItem * song = [[[MediaManager shared] getPlaylist] objectAtIndex:[indexPath indexAtPosition:1]];
    
    NSMutableAttributedString * detail = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", song.artist, song.albumTitle]];
    [detail addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(song.artist.length, song.albumTitle.length + 1)];
    
    cell.textLabel.text = [song valueForProperty: MPMediaItemPropertyTitle];
    cell.detailTextLabel.attributedText = detail;
    
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    [cell setPreservesSuperviewLayoutMargins:NO];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[MediaManager shared] getPlaylist].count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    int startIndex = [sourceIndexPath indexAtPosition:1];
    int endIndex = [destinationIndexPath indexAtPosition:1];
    
    [[MediaManager shared] moveIndex:startIndex toIndex:endIndex];
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        MPMediaItem * toDelete = [[[MediaManager shared] getPlaylist] objectAtIndex:[indexPath indexAtPosition:1]];
        [[MediaManager shared] removeSongFromPlaylist:[indexPath indexAtPosition:1]];
        [ibTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

@end
