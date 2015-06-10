//
//  CommentViewController.m
//  HackerNews
//
//  Created by Suraj Kumar on 6/4/15.
//  Copyright (c) 2015 Suraj Kumar. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentCell.h"
#import "AppDefaults.h"
#import "DownloadManager.h"

#define CELL_PADDING 20

@interface CommentViewController ()<CommentDownloadDelegate>
@property (nonatomic, strong) NSArray * commentArrayContent;
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AppDefaults getViewFrame:self];
    [AppDefaults addLoadingIndicator:self.view];
    [self setTableLayout];
    [self downloadData];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadData{
    [DownloadManager sharedInstance].commentDelegate = self;
    [[DownloadManager sharedInstance] fetchComments:self.commentArray];
}

-(void)setTableLayout{
    self.tableView.hidden = true;
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil]
         forCellReuseIdentifier:@"CommentCell"];
    self.tableView.backgroundColor = kTableViewBackgroundColor;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.commentArrayContent count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil];
    CommentCell *cell = [nib objectAtIndex:0];
    [self configureCommentCell:cell withIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *commentCellIdentifier = @"CommentCell";
    CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:commentCellIdentifier];
    [self configureCommentCell:cell withIndexPath:indexPath];
    return cell;
}

-(void)configureCommentCell:(CommentCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    cell.userLabel.text = [self.commentArrayContent[indexPath.row] valueForKey:@"by"];
    
    CGRect frame = cell.userLabel.frame;
    frame.size.width = cell.bgView.frame.size.width - CELL_PADDING;
    cell.userLabel.frame = frame;
    
    [cell.userLabel sizeToFit];
    
    NSString *text = [NSString stringWithFormat:@"<html><head>""<style type=\"text/css\"> \n"
                      "body {font-family: \"%@\"; font-size: %d; color: #182432;line-height:15px;}\n"
                      "</style> \n""</head><body>%@</body></html>",kFont,kSubheadingFontSize,[self.commentArrayContent[indexPath.row] valueForKey:@"text"]];
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

    cell.userComment.attributedText = attrStr;
    
    frame = cell.userComment.frame;
    frame.size.width = cell.bgView.frame.size.width - CELL_PADDING;
    cell.userComment.frame = frame;
    
    [cell.userComment sizeToFit];
    
    frame = cell.bgView.frame;
    frame.size.height = cell.userComment.frame.size.height + cell.userComment.frame.origin.y  + CELL_PADDING/2;
    cell.bgView.frame = frame;
    
    [AppDefaults addRoundedCornersToView:cell.bgView];
    
    frame = cell.frame;
    frame.size.height = cell.bgView.frame.size.height + CELL_PADDING;
    cell.frame = frame;
    
    [cell.contentView sizeToFit];
}

-(void)commentDownloadComplete:(NSArray *)array{
    self.commentArrayContent = array;
    [self.tableView reloadData];
    self.tableView.hidden = false;
    [AppDefaults removeLoadingIndicator:self.view];
}

@end
