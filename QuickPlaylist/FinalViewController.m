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

@interface FinalViewController ()<UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate>

@property AVAudioPlayer * player;
@property int currentIndex;

@end

@implementation FinalViewController

@synthesize ibTable;
@synthesize ibToolbar;
@synthesize player;
@synthesize currentIndex;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    ibTable.delegate = self;
    ibTable.dataSource = self;
    
    currentIndex = 0;
    
    [self setUpToolbar:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [ibTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
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
    [self setCellIndex:currentIndex isPlaying:NO];
    player = nil;
    currentIndex = (int)indexPath.row;
    [self play:nil];
    
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
    if([[MediaManager shared] getPlaylist].count == 0) return;
    
    if(player == nil){
        if(currentIndex >= [[MediaManager shared] getPlaylist].count || currentIndex < 0){
            currentIndex = 0;
            [self setUpToolbar:YES];
            [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;
            return;
        }
        
        MPMediaItem * song = [[[MediaManager shared] getPlaylist] objectAtIndex:currentIndex];
        
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = @{MPMediaItemPropertyTitle: song.title,
                                                                  MPMediaItemPropertyArtist: song.artist,
                                                                  MPMediaItemPropertyArtwork: song.artwork};
        
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[song valueForProperty:MPMediaItemPropertyAssetURL] error:nil];
        player.delegate = self;
        [player prepareToPlay];
        [player play];
        [self setCellIndex:currentIndex isPlaying:YES];
        [self setUpToolbar:NO];
    }
    else{
        if(player.isPlaying){
            [player pause];
            [self setUpToolbar:YES];
        }
        else{
            [player play];
            [self setUpToolbar:NO];
        }
    }
}

-(void)setCellIndex:(int)index isPlaying:(BOOL)playing
{
    NSUInteger indexes[] = {0, index};
    UITableViewCell * cell = [ibTable cellForRowAtIndexPath:[NSIndexPath indexPathWithIndexes:indexes length:2]];
    if(playing){
        [cell setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]];
    }
    else{
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
}

-(void)rewind:(id)sender
{
    [self setCellIndex:currentIndex isPlaying:NO];
    if(player.currentTime < 10.0){
        --currentIndex;
    }
    player = nil;
    [self play:nil];
}

-(void)fastForward:(id)sender
{
    [self setCellIndex:currentIndex isPlaying:NO];
    ++currentIndex;
    player = nil;
    [self play:nil];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)p successfully:(BOOL)flag
{
    [self setCellIndex:currentIndex isPlaying:NO];
    ++currentIndex;
    player = nil;
    [self play:nil];
}

-(void)stop
{
    [self setCellIndex:currentIndex isPlaying:NO];
    player = nil;
    currentIndex = 0;
    [self setUpToolbar:YES];
}

@end
