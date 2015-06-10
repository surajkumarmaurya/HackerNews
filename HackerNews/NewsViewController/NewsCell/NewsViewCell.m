//
//  NewsViewCell.m
//  HackerNews
//
//  Created by Suraj Kumar on 6/2/15.
//  Copyright (c) 2015 Suraj Kumar. All rights reserved.
//

#import "NewsViewCell.h"
#import "AppDefaults.h"

@implementation NewsViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.separatorView.layer.cornerRadius = self.separatorView.frame.size.width/2;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentLabel.font = [UIFont fontWithName:kFont size:kHeadingFontSize];
    self.readMoreLabel.font = [UIFont fontWithName:kFont size:kSubheadingFontSize];
    self.commentsLabel.font = [UIFont fontWithName:kFont size:kSubheadingFontSize];
    
    self.contentLabel.textColor = kHeadingLabelColor;
    self.readMoreLabel.textColor = kSubHeadingLabelColor;
    self.commentsLabel.textColor = kSubHeadingLabelColor;


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse{
    [super prepareForReuse];
}

@end
