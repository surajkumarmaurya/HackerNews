//
//  CommentViewController.h
//  HackerNews
//
//  Created by Suraj Kumar on 6/4/15.
//  Copyright (c) 2015 Suraj Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *commentArray;
@end
