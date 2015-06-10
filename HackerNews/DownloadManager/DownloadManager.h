//
//  DownloadManager.h
//  HackerNews
//
//  Created by Suraj Kumar on 6/2/15.
//  Copyright (c) 2015 Suraj Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TopStoryDownloadDelegate <NSObject>
-(void)topStoryDownloadComplete:(BOOL)isSuccess;
@end

@protocol CommentDownloadDelegate <NSObject>
-(void)commentDownloadComplete:(NSArray*)commentArray;
@end

@interface DownloadManager : NSObject
@property (nonatomic, weak) id<TopStoryDownloadDelegate>  topStoryDelegate;
@property (nonatomic, weak) id<CommentDownloadDelegate> commentDelegate;
@property (nonatomic) BOOL isFirstLaunch;

+ (DownloadManager *)sharedInstance;
-(void)fetchTopStoriesID;
-(void)fetchStoryContent;
-(NSArray *)getDataForTopStory;
-(void)fetchComments:(NSArray *)commentIDArray;
@end
