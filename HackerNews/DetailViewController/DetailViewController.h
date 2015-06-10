//
//  DetailViewController.h
//  
//
//  Created by Suraj Kumar on 6/2/15.
//
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSString *url;
@end
