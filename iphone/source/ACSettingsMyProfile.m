
#import "ACSettingsMyProfile.h"
#import "ACAppController.h"
#import "CacheGlobals.h"

extern ACSettings * settings_instance;

@implementation ACSettingsMyProfile
@synthesize username;
@synthesize location;
@synthesize tagCount;
@synthesize ratingView;
@synthesize activity;
@synthesize toolbar;
@synthesize content;
@synthesize tagsLabel;
@synthesize ratingLabel;

- (id) initWithNibName:(NSString *) nibNameOrNil bundle:(NSBundle *) nibBundleOrNil {
	if(!(self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) return nil;
	return self;
}

- (IBAction) refresh {
	[ACSettingsMyGallery expireCachedGalleryData];
	[ACProfileInfoService expireCache];
	[self performGetProfileInfo];
}

- (IBAction) back {
	[[app views] popViewControllerAnimated:false];
}

- (void) performGetProfileInfo {
	[app showServiceIndicator];
	GDRelease(profileInfoService);
	profileInfoService = [[ACProfileInfoService serviceWithUsername:[user username]] retain];
	[profileInfoService setJsonCacheKey:[ACProfileInfoService jsonCacheKey]];
	[profileInfoService setFinished:GDCreateCallback(self,profileInfoFinished) andFailed:GDCreateCallback(self,profileInfoFailed)];
	[profileInfoService sendAsync];
}

- (void) profileInfoFinished {
	[app hideServiceIndicator];
	NSDictionary * data = [profileInfoService data];
	NSNumber * totalTags = [data objectForKey:@"totalTags"];
	NSNumber * rating = [data objectForKey:@"rating"];
	NSNumber * rateCount = [data objectForKey:@"rateCount"];
	NSInteger rated = 1;
	if([rating intValue] > 0 && [rateCount intValue] > 0) rated = [rateCount intValue] / [rating intValue];
	if([totalTags intValue] < 1) rated = 1;
	if([totalTags intValue] < 0) [tagCount setText:@"0"];
	else [tagCount setText:[totalTags stringValue]];
	if([totalTags intValue] == 1) [tagsLabel setText:@"TAG"];
	else [tagsLabel setText:@"TAGS"];
	[username setText:[[user username] uppercaseString]];
	[ratingView setUserRating:rated];
	[ratingView setRating:rated];
	if(![content superview]) [[self view] addSubview:content];
	GDRelease(profileInfoService);
}

- (void) profileInfoFailed {
	[app hideServiceIndicator];
	[content removeFromSuperview];
	[profileInfoService showFaultMessage];
	[settings_instance showError];
	GDRelease(profileInfoService);
}

- (void) viewDidGoIn {
	if(!user) user = [ACUserInfo sharedInstance];
	[self performGetProfileInfo];
}

- (void) viewDidGoOut {
	
}

- (void) viewDidLoad {
	app = [ACAppController sharedInstance];
	picker = [[UIImagePickerController alloc] init];
	[ratingView setStarImage:[UIImage imageNamed:@"rating_star_half.png"] forState:kSCRatingViewHalfSelected];
	[ratingView setStarImage:[UIImage imageNamed:@"rating_star_cyan.png"] forState:kSCRatingViewHighlighted];
	[ratingView setStarImage:[UIImage imageNamed:@"rating_star_hot.png"] forState:kSCRatingViewHot];
	[ratingView setStarImage:[UIImage imageNamed:@"rating_star_cyan.png"] forState:kSCRatingViewSelected];
	[ratingView setStarImage:[UIImage imageNamed:@"rating_star_cyan.png"] forState:kSCRatingViewUserSelected];
	[ratingView setStarImage:[UIImage imageNamed:@"rating_star_gray.png"] forState:kSCRatingViewNonSelected];
	[ratingView setUserRating:4.3];
	[ratingView setUserInteractionEnabled:false];
	[FontLabelHelper setFont_AgencyFBBold_ForLabel:tagsLabel withPointSize:22];
	[FontLabelHelper setFont_AgencyFBRegular_ForLabel:username withPointSize:44];
	[FontLabelHelper setFont_AgencyFBBold_ForLabel:ratingLabel withPointSize:22];
	[FontLabelHelper setFont_AgencyFBRegular_ForLabel:tagCount withPointSize:90];
}

- (void) unloadView {
	if(picker)[picker setDelegate:nil];
	[self setView:nil];
}

- (void) viewDidUnload {
	[super viewDidUnload];
}

- (void) didReceiveMemoryWarning {
	if(![[self view] superview]) [self unloadView];
	[super didReceiveMemoryWarning];
}

- (void) dealloc {
	[self unloadView];
	GDRelease(content);
	GDRelease(username);
	GDRelease(location);
	GDRelease(tagCount);
	GDRelease(picker);
	GDRelease(activity);
	GDRelease(toolbar);
	GDRelease(ratingView);
	GDRelease(profileInfoService);
	GDRelease(tagsLabel);
	GDRelease(ratingLabel);
	app = nil;
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACSettingsMyProfile");
	#endif
	[super dealloc];
}

@end
