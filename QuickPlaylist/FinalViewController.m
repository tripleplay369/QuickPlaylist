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
#import "ArtworkCellTableViewCell.h"

const int VIEW_TAG = 100;

typedef enum{
    STATE_PLAY, STATE_PAUSE, STATE_STOP
}SongState;

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
    ibTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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
    ArtworkCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ArtworkCellTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    MPMediaItem * song = [[[MediaManager shared] getPlaylist] objectAtIndex:[indexPath indexAtPosition:1]];
    
    NSMutableAttributedString * detail = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", song.artist, song.albumTitle]];
    [detail addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(song.artist.length, song.albumTitle.length + 1)];
    
    cell.textLabel.text = [song valueForProperty: MPMediaItemPropertyTitle];
    cell.detailTextLabel.attributedText = detail;
    cell.imageView.image = [song.artwork imageWithSize:CGSizeMake(43, 43)];
    
    [[cell.contentView viewWithTag:VIEW_TAG] removeFromSuperview];
    
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
    [self setCellIndex:currentIndex toState:STATE_STOP];
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
        [self setCellIndex:currentIndex toState:STATE_PLAY];
        [self setUpToolbar:NO];
    }
    else{
        if(player.isPlaying){
            [player pause];
            [self setCellIndex:currentIndex toState:STATE_PAUSE];
            [self setUpToolbar:YES];
        }
        else{
            [player play];
            [self setCellIndex:currentIndex toState:STATE_PLAY];
            [self setUpToolbar:NO];
        }
    }
}

-(void)setCellIndex:(int)index toState:(SongState)state
{
    NSUInteger indexes[] = {0, index};
    ArtworkCellTableViewCell * cell = (ArtworkCellTableViewCell *)[ibTable cellForRowAtIndexPath:[NSIndexPath indexPathWithIndexes:indexes length:2]];
    
    [[cell.contentView viewWithTag:VIEW_TAG] removeFromSuperview];
    
    if(state == STATE_PLAY){
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play.png"]];
        imageView.frame = CGRectMake(self.view.frame.size.width - 30, 12, 20, 20);
        imageView.tag = VIEW_TAG;
        [cell.contentView addSubview:imageView];
        cell.leaveRoomForIcon = YES;
        [cell layoutSubviews];
    }
    else if(state == STATE_PAUSE){
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pause.png"]];
        imageView.frame = CGRectMake(self.view.frame.size.width - 30, 12, 20, 20);
        imageView.tag = VIEW_TAG;
        [cell.contentView addSubview:imageView];
        cell.leaveRoomForIcon = YES;
        [cell layoutSubviews];
    }
    else{
        cell.leaveRoomForIcon = NO;
        [cell layoutSubviews];
    }
}

-(void)rewind:(id)sender
{
    [self setCellIndex:currentIndex toState:STATE_STOP];
    if(player.currentTime < 10.0){
        --currentIndex;
    }
    player = nil;
    [self play:nil];
}

-(void)fastForward:(id)sender
{
    [self setCellIndex:currentIndex toState:STATE_STOP];
    ++currentIndex;
    player = nil;
    [self play:nil];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)p successfully:(BOOL)flag
{
    [self setCellIndex:currentIndex toState:STATE_STOP];
    ++currentIndex;
    player = nil;
    [self play:nil];
}

-(void)stop
{
    [self setCellIndex:currentIndex toState:STATE_STOP];
    player = nil;
    currentIndex = 0;
    [self setUpToolbar:YES];
}

@end
