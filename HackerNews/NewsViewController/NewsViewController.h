//
//  NewsViewController.h
//  HackerNews
//
//  Created by Suraj Kumar on 6/2/15.
//  Copyright (c) 2015 Suraj Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "DownloadManager.h"

@interface NewsViewController : RootViewController<TopStoryDownloadDelegate>

@end
