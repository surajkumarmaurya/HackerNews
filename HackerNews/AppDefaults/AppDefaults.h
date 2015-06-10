//
//  AppDefaults.h
//  HackerNews
//
//  Created by Suraj Kumar on 6/6/15.
//  Copyright (c) 2015 Suraj Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define TOP_STORIES_URL                      @"https://hacker-news.firebaseio.com/v0/topstories.json"
#define SINGLE_STORY_URL                    @"https://hacker-news.firebaseio.com/v0/item/%@.json?print=pretty"
#define SINGLE_COMMENT_URL                    @"https://hacker-news.firebaseio.com/v0/item/%@.json?print=pretty"

#define kFont                                @"American Typewriter"
#define kHeadingFontSize                    15
#define kSubheadingFontSize                 12
#define kHeadingLabelColor                  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1]
#define kSubHeadingLabelColor               [UIColor colorWithRed:0/255.0 green:128.0/255.0 blue:255.0/255.0 alpha:1]

#define kTableViewBackgroundColor           [UIColor colorWithRed:156.0/255.0 green:172.0/255.0 blue:192.0/255.0 alpha:1]

@interface AppDefaults : NSObject
+(NSString *)getTopStoryURL;
+(NSString *)getSingleStoryURL:(NSNumber*)storyID;
+(NSString *)getSingleCommentURL:(NSNumber*)storyID;
+(void)addAttributedStrikeThroughString:(UILabel *)label;
+(CGRect) getViewFrame:(UIViewController *)inputViewController;
+(void)addLoadingIndicator:(UIView *)view;
+(void)removeLoadingIndicator:(UIView *)view;
+(void)addRoundedCornersToView:(UIView *)view;
+ (BOOL)checkInternetConnection;
@end
