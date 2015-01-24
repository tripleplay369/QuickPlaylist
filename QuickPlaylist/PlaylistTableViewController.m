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
    
    cell.textLabel.text = [song valueForProperty: MPMediaItemPropertyTitle];
    cell.detailTextLabel.text = [song valueForProperty:MPMediaItemPropertyArtist];
    
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
        [[MediaManager shared] removeSongFromPlaylist:toDelete];
        [ibTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

@end
