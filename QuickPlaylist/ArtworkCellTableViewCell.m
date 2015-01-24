//
//  ArtworkCellTableViewCell.m
//  QuickPlaylist
//
//  Created by Kelby on 1/24/15.
//  Copyright (c) 2015 Kelby Green. All rights reserved.
//

#import "ArtworkCellTableViewCell.h"

@implementation ArtworkCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(7, 7, 30, 30);
    self.textLabel.frame = CGRectMake(43, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
    self.detailTextLabel.frame = CGRectMake(43, self.detailTextLabel.frame.origin.y, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height);
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins = UIEdgeInsetsZero;
    [self setPreservesSuperviewLayoutMargins:NO];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

@end
