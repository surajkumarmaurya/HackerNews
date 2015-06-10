//
//  DownloadManager.m
//  HackerNews
//
//  Created by Suraj Kumar on 6/2/15.
//  Copyright (c) 2015 Suraj Kumar. All rights reserved.
//

#import "DownloadManager.h"
#import "AppDefaults.h"
#import "DataManager.h"
#import "Stories.h"
#import "CommentID.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface DownloadManager ()
@property (nonatomic, strong) NSArray *topStoriesID;
@property (nonatomic, strong) NSManagedObjectContext *objectContext;
@property (nonatomic) NSInteger count;
@end

@implementation DownloadManager

+ (DownloadManager *)sharedInstance
{
    static dispatch_once_t pred;
    static DownloadManager *sharedInstance = nil;
    
    dispatch_once(&pred, ^{ sharedInstance = [[self alloc] init]; });
    return sharedInstance;
}

-(void)initialise{
    self.count = 0;
    _isFirstLaunch = true;
    [self deleteDataForTopStory];
}

-(void)fetchTopStoriesID{
    [self initialise];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    [manager GET:[AppDefaults getTopStoryURL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.topStoriesID = responseObject;
        [self fetchStoryContent];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
}

-(void)fetchStoryContent{
    if(self.count >= [self.topStoriesID count]){
        [self.topStoryDelegate topStoryDownloadComplete:false];
        return;
    }
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    [manager GET:[AppDefaults getSingleStoryURL:self.topStoriesID[self.count]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self saveStoriesContent:responseObject];
        self.count++;
        if(_isFirstLaunch){
            if(self.count%50 == 0){
                [self.topStoryDelegate topStoryDownloadComplete:true];
                _isFirstLaunch = false;
                return;
            }
        }else if(self.count%10 == 0){
            [self.topStoryDelegate topStoryDownloadComplete:true];
            return;
        }
        [self fetchStoryContent];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
}

-(void)saveStoriesContent:(NSDictionary *)story{
    self.objectContext = [DataManager sharedInstance].managedObjectContext;
    Stories *stories = [NSEntityDescription insertNewObjectForEntityForName:@"Stories" inManagedObjectContext:self.objectContext];
    stories.url = [story objectForKey:@"url"];
    stories.title = [story objectForKey:@"title"];
    stories.storyID = [story objectForKey:@"id"];
    stories.score = [story objectForKey:@"score"];
    NSArray *kids = [story objectForKey:@"kids"];
    for(int i =0; i<[kids count];i++){
        CommentID *commentID = [NSEntityDescription insertNewObjectForEntityForName:@"CommentID" inManagedObjectContext:self.objectContext];
        commentID.stories = stories;
        commentID.commentID = kids[i];
    }
    [self saveDataNow];
}

-(NSArray *)getDataForTopStory{
    self.objectContext = [DataManager sharedInstance].managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stories"
                                              inManagedObjectContext:self.objectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"score"
                                                                   ascending:NO];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    NSError *error;
    NSArray *fetchedResults = [self.objectContext executeFetchRequest:fetchRequest error:&error];
    return fetchedResults;
}

-(void)deleteDataForTopStory{
    NSArray *array = [self getDataForTopStory];
    for (NSManagedObject *managedObject in array) {
        [self.objectContext deleteObject:managedObject];
    }
}

-(void)fetchComments:(NSArray *)commentIDArray{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSMutableArray  *commentArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [commentIDArray count];i++){
        [manager GET:[AppDefaults getSingleCommentURL:commentIDArray[i]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if([responseObject valueForKey:@"by"] != nil && [responseObject valueForKey:@"text"]!= nil)
            [commentArray addObject:responseObject];
            if([commentArray count] == [commentIDArray count]){
                [self.commentDelegate commentDownloadComplete:commentArray];
                return;
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",[error localizedDescription]);
        }];
        
    }
}

- (void)saveDataNow {
    NSError *error;
    [self.objectContext lock];
    if (![self.objectContext save:&error])
        NSLog(@"Error while saving: %@\n%@", [error localizedDescription], [error userInfo]);
    [[self objectContext] unlock];
}


@end
