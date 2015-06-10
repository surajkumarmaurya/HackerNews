//
//  NewsViewController.m
//  HackerNews
//
//  Created by Suraj Kumar on 6/2/15.
//  Copyright (c) 2015 Suraj Kumar. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsViewCell.h"
#import "DetailViewController.h"
#import "CommentViewController.h"
#import "Stories.h"
#import "CommentID.h"
#import "AppDefaults.h"

#define kIndicatorSize 10
#define CELL_PADDING 5

@interface NewsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *storiesArray;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UILabel *noContentLabel;
@end

@implementation NewsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.storiesArray = [[NSMutableArray alloc] init];
        self.view.frame = [AppDefaults getViewFrame:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchCachedData];
    [self setTableLayout];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

// Setting up Navigation Controller
-(void)setNavigationBar{
    self.navigationItem.title = @"Hacker News";
    self.navigationItem.rightBarButtonItem = [self setRightMenuButton];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
}

-(UIBarButtonItem *)setRightMenuButton{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
}

// Refreshing Table For New Content
-(void)refreshData{
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.frame.origin.y - 64)];
    [self stopLoadingView];
    [self downloadNewData];
}


// Seetting up Table
-(void)setTableLayout{
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsViewCell" bundle:nil]
         forCellReuseIdentifier:@"NewsCell"];
    self.tableView.backgroundColor = kTableViewBackgroundColor;
    [self addActivityIndicator];
}

-(void)addActivityIndicator{
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.hidesWhenStopped = true;
    _activityIndicator.frame = CGRectMake(self.view.frame.size.width/2 - kIndicatorSize/2, kIndicatorSize/2, kIndicatorSize, kIndicatorSize);
    
    _noContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kIndicatorSize/2, self.tableView.frame.size.width, 2*kIndicatorSize)];
    _noContentLabel.text = @"No More Content. Please Refresh.";
    _noContentLabel.textAlignment = NSTextAlignmentCenter;
    _noContentLabel.font = [UIFont fontWithName:kFont size:kSubheadingFontSize];
    _noContentLabel.textColor = kSubHeadingLabelColor;
    _noContentLabel.hidden = true;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 2.5*kIndicatorSize)];
    [footerView addSubview:_activityIndicator];
    [footerView addSubview:_noContentLabel];
    self.tableView.tableFooterView = footerView;
}

#pragma TableViewDelegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.storiesArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewsViewCell" owner:self options:nil];
    NewsViewCell *cell = [nib objectAtIndex:0];
    [self configureNewsCell:cell withIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *newsCellIdentifier = @"NewsCell";
    NewsViewCell *cell = (NewsViewCell *)[tableView dequeueReusableCellWithIdentifier:newsCellIdentifier];
    [self configureNewsCell:cell withIndexPath:indexPath];
    return cell;
}

// Configuring Cell
-(void)configureNewsCell:(NewsViewCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    Stories *story = [self.storiesArray objectAtIndex:indexPath.row];
    
    cell.contentLabel.text = story.title;
    
    CGRect frame = cell.contentLabel.frame;
    frame.size.width = cell.bgView.frame.size.width - 4*CELL_PADDING;
    cell.contentLabel.frame = frame;
    
    [cell.contentLabel sizeToFit];
    
    cell.readMoreLabel.text = @"Read More";

    if(!story.url){
        [AppDefaults addAttributedStrikeThroughString:cell.readMoreLabel];
    }else{
        [self addReadMoreTapGesture:cell];
    }
    
    NSArray * relatedComment = [story.commentID array];
    NSMutableArray *commentID = [[NSMutableArray alloc] init];
    for(CommentID *ids in relatedComment){
        [commentID addObject:ids.commentID];
    }
    cell.commentsLabel.text = [NSString stringWithFormat:@"Comments (%lu)",(unsigned long)[commentID count]];

    if([commentID count]){
        [self addCommentTapGesture:cell];
    }else{
        [AppDefaults addAttributedStrikeThroughString:cell.commentsLabel];
    }
    
    frame = cell.readMoreLabel.frame;
    frame.origin.y = cell.contentLabel.frame.origin.y + cell.contentLabel.frame.size.height + CELL_PADDING;
    cell.readMoreLabel.frame = frame;
    
    frame = cell.separatorView.frame;
    frame.origin.y = cell.contentLabel.frame.origin.y + cell.contentLabel.frame.size.height + 12;
    cell.separatorView.frame = frame;
    
    frame = cell.commentsLabel.frame;
    frame.origin.y = cell.contentLabel.frame.origin.y + cell.contentLabel.frame.size.height + CELL_PADDING;
    cell.commentsLabel.frame = frame;
    
    frame = cell.bgView.frame;
    frame.size.height = cell.commentsLabel.frame.origin.y + cell.commentsLabel.frame.size.height + CELL_PADDING;
    cell.bgView.frame = frame;
    
    
    frame = cell.frame;
    frame.size.height = cell.bgView.frame.origin.y + cell.bgView.frame.size.height + CELL_PADDING;
    cell.frame = frame;
    
    [AppDefaults addRoundedCornersToView:cell.bgView];
    [cell.contentView sizeToFit];
}

// Adding Gesture To Read More Label To display corresponding URL content
-(void)addReadMoreTapGesture:(NewsViewCell *)cell{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleReadMorePressed:)];
    gesture.numberOfTapsRequired = 1;
    [cell.readMoreLabel addGestureRecognizer:gesture];
}

-(void)handleReadMorePressed:(UITapGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    Stories *story = self.storiesArray[indexPath.row];
    if(story.url){
        DetailViewController *detailViewController = [[DetailViewController alloc] init];
        detailViewController.url = story.url;
        [self.navigationController pushViewController:detailViewController animated:true];
    }
}

// Adding Gesture to Comment Label to show Corresponding Comments
-(void)addCommentTapGesture:(NewsViewCell *)cell{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCommentLabelPressed:)];
    gesture.numberOfTapsRequired = 1;
    [cell.commentsLabel addGestureRecognizer:gesture];
}

-(void)handleCommentLabelPressed:(UITapGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    Stories *story = self.storiesArray[indexPath.row];
    NSArray * relatedComment = [story.commentID array];
    NSMutableArray *commentID = [[NSMutableArray alloc] init];
    for(CommentID *ids in relatedComment){
        [commentID addObject:ids.commentID];
    }
    if([commentID count]){
        CommentViewController *commentViewController = [[CommentViewController alloc] init];
        commentViewController.commentArray = commentID;
        [self.navigationController pushViewController:commentViewController animated:true];
    }
}

// Scroll For Lazy Loading
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    int currentOffset = offset.y + bounds.size.height - inset.bottom;
    int height = size.height;
    if(currentOffset >= height && offset.y > 0 && [AppDefaults checkInternetConnection]){
        [self showActivityIndicator];
    }
}

-(void)showActivityIndicator{
    if (!self.activityIndicator.isAnimating && [_noContentLabel isHidden]) {
        [self.activityIndicator startAnimating];
        [[DownloadManager sharedInstance] fetchStoryContent];
    }
    
}

// Stopping Loading Indicators
-(void)stopLoadingView{
    [AppDefaults removeLoadingIndicator:self.view];
    [_activityIndicator stopAnimating];
}

// fetching Cache Data
-(void)fetchCachedData{
    [self.storiesArray addObjectsFromArray:[[DownloadManager sharedInstance] getDataForTopStory]];
    [self downloadNewData];
}

// Downloading New Content
-(void)downloadNewData{
    if([AppDefaults checkInternetConnection]){
        [AppDefaults addLoadingIndicator:self.view];
        [DownloadManager sharedInstance].topStoryDelegate = self;
        [[DownloadManager sharedInstance] fetchTopStoriesID];
    }
}

// Delegate Method to confirm DataDownload finished
-(void)topStoryDownloadComplete:(BOOL)isSuccess{
    [self stopLoadingView];
    if(isSuccess){
        if([DownloadManager sharedInstance].isFirstLaunch){
            [self.storiesArray removeAllObjects];
        }
        NSArray *newArray = [self checkForDuplicateEntries:[[DownloadManager sharedInstance] getDataForTopStory]];
        [self.storiesArray addObjectsFromArray:newArray];
        [self.tableView reloadData];
    }else{
        _noContentLabel.hidden = false;
    }
}

// To remove Duplicate entries from Table
-(NSArray *)checkForDuplicateEntries:(NSArray *)feedEntries {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (id entry in self.storiesArray){
        Stories *story = (Stories *)entry;
        [array addObject:story.storyID];
    }
    
    
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:feedEntries];
    NSMutableArray *deleteItemArray = [[NSMutableArray alloc] init];
    for (id entry in feedEntries){
        Stories *story = (Stories *)entry;
        if ([array containsObject:story.storyID])
            [deleteItemArray addObject:entry];
    }
    
    [dataArray removeObjectsInArray:deleteItemArray];
    return [NSArray arrayWithArray:dataArray];
}

@end
