
#import <Foundation/Foundation.h>

@class ACAppController;

@interface ACAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow * window;
	ACAppController * appController;
}

@property (nonatomic,retain) UIWindow * window;

@end
