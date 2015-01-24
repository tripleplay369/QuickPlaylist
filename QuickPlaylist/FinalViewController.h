//
//  FinalViewController.h
//  QuickPlaylist
//
//  Created by Kelby on 3/28/14.
//  Copyright (c) 2014 Kelby Green. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinalViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *ibTable;
@property (weak, nonatomic) IBOutlet UIToolbar *ibToolbar;

-(void)play:(id)sender;
-(void)rewind:(id)sender;
-(void)fastForward:(id)sender;

@end
