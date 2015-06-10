//
//  CommentCell.h
//  HackerNews
//
//  Created by Suraj Kumar on 6/4/15.
//  Copyright (c) 2015 Suraj Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *userComment;

@end
