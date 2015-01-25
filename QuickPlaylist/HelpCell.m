//
//  HelpCell.m
//  QuickPlaylist
//
//  Created by Kelby on 1/25/15.
//  Copyright (c) 2015 Kelby Green. All rights reserved.
//

#import "HelpCell.h"

@implementation HelpCell

@synthesize smallIcon;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if(smallIcon){
        self.imageView.frame = CGRectMake(12,12,20,20);
        self.textLabel.frame = CGRectMake(44, self.textLabel.frame.origin.y, self.frame.size.width - 44, self.textLabel.frame.size.height);
    }
    else{
        self.imageView.frame = CGRectMake(7,7,30,30);
        self.textLabel.frame = CGRectMake(44, self.textLabel.frame.origin.y, self.frame.size.width - 44, self.textLabel.frame.size.height);
    }
}

@end
