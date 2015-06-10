//
//  AppDefaults.m
//  HackerNews
//
//  Created by Suraj Kumar on 6/6/15.
//  Copyright (c) 2015 Suraj Kumar. All rights reserved.
//

#import "AppDefaults.h"
#import <MBProgressHUD.h>
#import <Reachability.h>

@implementation AppDefaults

+(NSString *)getTopStoryURL{
    return TOP_STORIES_URL;
}

+(NSString *)getSingleStoryURL:(NSNumber*)storyID{
    return [NSString stringWithFormat:SINGLE_STORY_URL,storyID];
}

+(NSString *)getSingleCommentURL:(NSNumber*)storyID{
    return [NSString stringWithFormat:SINGLE_COMMENT_URL,storyID];
}

+(void)addAttributedStrikeThroughString:(UILabel *)label{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:label.text];
    [attributeString addAttribute:NSStrikethroughStyleAttributeName
                            value:@1
                            range:NSMakeRange(0, [attributeString length])];
    label.attributedText = attributeString;
}

+(CGRect) getViewFrame:(UIViewController *)inputViewController {
    CGFloat navigationBarHeight = 44;
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= navigationBarHeight + statusBarHeight;
    return frame;
}

+(void)addLoadingIndicator:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:true];
    hud.labelText = @"Loading...";
}

+(void)removeLoadingIndicator:(UIView *)view{
    [MBProgressHUD hideAllHUDsForView:view animated:true];
}

+(void)addRoundedCornersToView:(UIView *)view{
    CALayer *layer = view.layer;
    CGRect frame = layer.bounds;
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)].CGPath;
    [layer addSublayer:maskLayer];
    layer.mask = maskLayer;
}

+ (BOOL)checkInternetConnection {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    return !(networkStatus == NotReachable);
}

@end
