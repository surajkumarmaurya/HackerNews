//
//  CommentCell.m
//  HackerNews
//
//  Created by Suraj Kumar on 6/4/15.
//  Copyright (c) 2015 Suraj Kumar. All rights reserved.
//

#import "CommentCell.h"
#import "AppDefaults.h"

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    self.userComment.textColor = kSubHeadingLabelColor;
    self.userComment.font = [UIFont fontWithName:kFont size:kSubheadingFontSize];
    
    self.userLabel.font = [UIFont fontWithName:kFont size:kHeadingFontSize];
    self.userLabel.textColor = kHeadingLabelColor;


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
