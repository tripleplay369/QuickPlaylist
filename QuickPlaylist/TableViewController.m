//
//  TableViewController.m
//  QuickPlaylist
//
//  Created by Kelby on 3/28/14.
//  Copyright (c) 2014 Kelby Green. All rights reserved.
//

#import "TableViewController.h"

#import "MediaManager.h"
#import "ArtworkCellTableViewCell.h"
#import "CustomPullToRefreshControl.h"

@interface TableViewController()<UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray * songs;
@property CustomPullToRefreshControl * refreshControl;

@end

@implementation TableViewController

@synthesize songs;
@synthesize ibTable;
@synthesize refreshControl;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    ibTable.dataSource = self;
    ibTable.delegate = self;
    ibTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    refreshControl = [[CustomPullToRefreshControl alloc] initInScrollView:ibTable];
    refreshControl.tintColor = [UIColor blackColor];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    [self refresh];
}

-(void)refresh
{
    int songsPerPage = (ibTable.frame.size.height / 44.0) - 1;
    
    NSMutableArray * randomSongs = [NSMutableArray array];
    for(int i = 0; i < songsPerPage; ++i){
        [randomSongs addObject:[[MediaManager shared] getRandomSong]];
    }
    
    songs = randomSongs;
    
    [refreshControl endRefreshing];
    [ibTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ArtworkCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[ArtworkCellTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
    }
    
    MPMediaItem * song = [songs objectAtIndex:[indexPath indexAtPosition:1]];
    
    NSMutableAttributedString * detail = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", song.artist, song.albumTitle]];
    [detail addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(song.artist.length, song.albumTitle.length + 1)];
    
    cell.textLabel.text = [song valueForProperty: MPMediaItemPropertyTitle];
    cell.detailTextLabel.attributedText = detail;
    cell.imageView.image = [song.artwork imageWithSize:CGSizeMake(43, 43)];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return songs.count;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPMediaItem * song = [songs objectAtIndex:[indexPath indexAtPosition:1]];
    [[MediaManager shared] addSongToPlaylist:song];
    [songs removeObject:song];
    [ibTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    return nil;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Tap to add to playlist, pull down to refresh.";
}

@end
