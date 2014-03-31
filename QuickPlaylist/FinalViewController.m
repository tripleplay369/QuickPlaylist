//
//  FinalViewController.m
//  QuickPlaylist
//
//  Created by Kelby on 3/28/14.
//  Copyright (c) 2014 Kelby Green. All rights reserved.
//

#import "FinalViewController.h"

#import "MediaManager.h"

@interface FinalViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation FinalViewController

@synthesize ibTable;
@synthesize ibToolbar;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    ibTable.delegate = self;
    ibTable.dataSource = self;
    
    [self setUpToolbar:YES];
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

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(void)setUpToolbar:(BOOL)play
{
    UIBarButtonItem * item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(rewind:)];
    
    UIBarButtonSystemItem type = play ? UIBarButtonSystemItemPlay : UIBarButtonSystemItemPause;
    UIBarButtonItem * item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:type target:self action:@selector(play:)];
    
    UIBarButtonItem * item3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(fastForward:)];
    
    UIBarButtonItem * flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [ibToolbar setItems:@[item1, flex, item2, flex, item3]];
}

-(void)play:(id)sender
{
    ;
}

-(void)rewind:(id)sender
{
    ;
}

-(void)fastForward:(id)sender
{
    ;
}

@end
