
#import <UIKit/UIKit.h>
#import "macros.h"

@class ACAppController;

@interface ACHelp : UIViewController <UIWebViewDelegate> {
	UIWebView * webview;
	ACAppController * app;
}

@property (nonatomic,retain) IBOutlet UIWebView * webview;

- (IBAction) back;

@end
