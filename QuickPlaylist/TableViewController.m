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
@property BOOL initialRefresh;

@end

@implementation TableViewController

@synthesize songs;
@synthesize ibTable;
@synthesize refreshControl;
@synthesize initialRefresh;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    ibTable.dataSource = self;
    ibTable.delegate = self;
    ibTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    refreshControl = [[CustomPullToRefreshControl alloc] initInScrollView:ibTable];
    refreshControl.tintColor = [UIColor blackColor];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    initialRefresh = YES;
}

-(void)viewDidLayoutSubviews
{
    if(initialRefresh){
        [self refresh];
    }
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

-(void)refresh
{
    int songsPerPage = (ibTable.frame.size.height / 44.0);
    
    NSMutableArray * randomSongs = [[MediaManager shared] getRandomSongs:songsPerPage];
    
    songs = randomSongs;
    
    [refreshControl endRefreshing];
    if(initialRefresh){
        initialRefresh = NO;
        [ibTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
    else{
        [ibTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    }
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
    return nil;
}

@end
