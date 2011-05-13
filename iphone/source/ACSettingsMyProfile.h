
#import <UIKit/UIKit.h>
#import "SCRatingView.h"
#import "ACServiceUrls.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ACAlerts.h"
#import "ACUserInfo.h"
#import "ACProfileInfoService.h"
#import "ACSettingsMyGallery.h"
#import "FontLabelHelper.h"

@class ACAppController;

@interface ACSettingsMyProfile : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, ASIHTTPRequestDelegate> {
	UILabel * location;
	UIView * content;
	UIImagePickerController * picker;
	UIActivityIndicatorView * activity;
	UIToolbar * toolbar;
	FontLabel * tagsLabel;
	FontLabel * tagCount;
	FontLabel * ratingLabel;
	FontLabel * username;
	ACUserInfo * user;
	ACAppController * app;
	SCRatingView * ratingView;
	ACProfileInfoService * profileInfoService;
}

@property (nonatomic,retain) IBOutlet UILabel * location;
@property (nonatomic,retain) IBOutlet SCRatingView * ratingView;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView * activity;
@property (nonatomic,retain) IBOutlet UIToolbar * toolbar;
@property (nonatomic,retain) IBOutlet UIView * content;
@property (nonatomic,retain) IBOutlet FontLabel * tagCount;
@property (nonatomic,retain) IBOutlet FontLabel * username;
@property (nonatomic,retain) IBOutlet FontLabel * tagsLabel;
@property (nonatomic,retain) IBOutlet FontLabel * ratingLabel;

- (void) unloadView;
- (void) performGetProfileInfo;
- (IBAction) back;
- (IBAction) refresh;

@end
