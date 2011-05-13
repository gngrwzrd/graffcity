
#import "ACTagLayout.h"
#import "ACAppController.h"


@implementation ACTagLayout
@synthesize delegate;
@synthesize toggleMoveMode;
@synthesize tag;
@synthesize background;
@synthesize blendingModes;

static bool postedThumbToStorage = false;
static bool postedLargeToStorage = false;
static bool triedPostThumb = false;
static bool triedPostLarge = false;

- (void) viewDidLoad {
	app = [ACAppController sharedInstance];
	rotX = 0;
	rotY = 0;
	geoTries = 3;
	isFacebooking = false;
	backgroundSelected = false;
	transform3D = CATransform3DIdentity;
	selectedImage = tag;
	containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	prompt = [[UserAccountPrompt alloc] initWithNibName:@"UserAccountPrompt" bundle:nil];
	[prompt setDelegate:self];
	[containerView setCenter:CGPointMake(160,240)];
	[containerView setUserInteractionEnabled:NO];
	[saveOptions setCenter:CGPointMake(160,240)];
	[[self view] insertSubview:containerView atIndex:0];
	blendingEnabled = true;
	if(blendingEnabled) {
		blendView = [[ACBlendModeView alloc] initWithFrame:CGRectMake(0,0,320,480)];
		blendView.userInteractionEnabled = false;
		[containerView addSubview:blendView];
	}
	[self resetViews];
}

- (IBAction) bmnormal {
	[blendView setIndexAndUpdate:0];
}

- (IBAction) bmmultiply {
	[blendView setIndexAndUpdate:1];
}

- (IBAction) bmscreen {
	[blendView setIndexAndUpdate:2];
}

- (IBAction) bmoverlay {
	[blendView setIndexAndUpdate:3];
}

- (IBAction) bmdarken {
	[blendView setIndexAndUpdate:4];
}

- (IBAction) bmlighten {
	[blendView setIndexAndUpdate:5];
}

- (IBAction) bmdodge {
	[blendView setIndexAndUpdate:6];
}

- (IBAction) bmburn {
	[blendView setIndexAndUpdate:7];
}

- (IBAction) bmsoftlight {
	[blendView setIndexAndUpdate:8];
}

- (IBAction) bmhardlight {
	[blendView setIndexAndUpdate:9];
}

- (IBAction) bmdifference {
	[blendView setIndexAndUpdate:10];
}

- (IBAction) bmexclusion {
	[blendView setIndexAndUpdate:11];
}

- (IBAction) bmhue {
	[blendView setIndexAndUpdate:12];
}

- (IBAction) bmsaturation {
	[blendView setIndexAndUpdate:13];
}

- (IBAction) bmcolor {
	[blendView setIndexAndUpdate:14];
}

- (IBAction) bmluminosity {
	[blendView setIndexAndUpdate:15];
}

- (IBAction) email {
	UIImage * img = [self compositeImage];
	NSData * jpg = UIImageJPEGRepresentation(img,.75);
	MFMailComposeViewController * mail = [[[MFMailComposeViewController alloc] init] autorelease];
	[mail setSubject:@"Tag From Graff City"];
	[mail addAttachmentData:jpg mimeType:@"image/jpg" fileName:@"graffcitytag.jpg"];
	[self presentModalViewController:mail animated:true];
	[mail setMailComposeDelegate:self];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[controller dismissModalViewControllerAnimated:true];
}

- (IBAction) mms {
	
}

- (IBAction) facebook {
	if(imageNameForFacebook) {
		[self shareToFacebook:imageNameForFacebook];
		return;
	}
	user = [ACUserInfo sharedInstance];
	isFacebooking = true;
	if(![user isLoggedIn]) {
		[self presentModalViewController:prompt animated:true];
		return;
	}
	[app showServiceIndicator];
	[app updateGEOInformationWithCompleteCallback:GDCreateCallback(self,onGEOComplete) andFailCallback:GDCreateCallback(self,onGEOFailed)];
}

- (IBAction) wallpaper {
	
}

- (void) addTag:(UIImage *) image {
	[tag setImage:NULL];
	GDRelease(tag);
	tag = [[UIImageView alloc] initWithImage:image];
	[self resetViews];
}

- (void) addBackground:(UIImage *) image {
	[background setImage:NULL];
	GDRelease(background);
	background = [[UIImageView alloc] initWithImage:image];
	[self resetViews];
}

- (void) hide {
	[containerView removeAllSubviews];
	[saveOptions removeFromSuperview];
	if(tag != nil) GDRelease(tag);
	if(background != nil) GDRelease(background);
}

- (void) resetViews {
	if(containerView == nil) return;
	[containerView removeAllSubviews];
	[containerView addSubview:background];
	[containerView addSubview:tag];
	selectedImage = tag;
	//make sure the background is scaled
	float perX = self.view.frame.size.width/background.frame.size.width;
	float perY = self.view.frame.size.height/background.frame.size.height;
	// reposition the background after scaling
	if(perX > perY) background.transform = CGAffineTransformScale(background.transform, perX, perX);	
	else background.transform = CGAffineTransformScale(background.transform, perY, perY);
	background.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
	// reposition the tag after scaling
	perX = self.view.frame.size.width/tag.frame.size.width;
	perY = self.view.frame.size.height/tag.frame.size.height;
	if(perX < perY) tag.transform = CGAffineTransformScale(tag.transform, perX, perX);
	else tag.transform = CGAffineTransformScale(tag.transform, perY, perY);
	tag.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
	[self checkButtonStates];
	[saveOptions removeFromSuperview];
	if(tag != nil && background != nil) {
		if(blendingEnabled) {
			[blendView compositeBackground:background withTag:tag];
			[containerView insertSubview:blendView atIndex:2];
		}
	}
}

- (UIImage *) compositeImage {
	CGRect boundBox = CGRectMake(0,0,320,480);
	UIGraphicsBeginImageContext(boundBox.size);
	if([blendView index] > 0) [blendView.layer renderInContext:UIGraphicsGetCurrentContext()];
	else [containerView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage * outputImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return outputImage;
}

- (IBAction) postToServer:(id) sender {
	geoTries = 3;
	isFacebooking = false;
	user = [ACUserInfo sharedInstance];
	if(![user isLoggedIn]) {
		[self presentModalViewController:prompt animated:true];
		return;
	}
	[app showServiceIndicator];
	[app updateGEOInformationWithCompleteCallback:GDCreateCallback(self,onGEOComplete) andFailCallback:GDCreateCallback(self,onGEOFailed)];
}

- (void) executePostToStorage {
	geoTries = 3;
	postedLargeToStorage = false;
	postedThumbToStorage = false;
	triedPostLarge = false;
	triedPostThumb = false;
	UIImage * image = [self compositeImage];
	// UIImage * thumb = [[ACStickerManager sharedInstance] createThumbnail:image withWidth:130 andHeight:78];
	
	PXRImageLib *imgLib = [[[PXRImageLib alloc] init] autorelease];
	UIImage *thumb = [imgLib crop:image withSize:CGSizeMake(130, 78) alignVertical:kimageBoundsVerticalAlignMiddle andHorizontal:kimageBoundsHorizontalAlignCenter];
	
	NSData * jpg = UIImageJPEGRepresentation(image,.75);
	NSData * jpgt = UIImageJPEGRepresentation(thumb,.85);
	NSString * larges = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/large.dat"];
	NSString * thumbs = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/thumb.dat"];
	[jpg writeToFile:larges atomically:true];
	[jpgt writeToFile:thumbs atomically:true];
	[thumbPrefix release];
	[thumbFilename release];
	[largePrefix release];
	[largeFilename release];
	thumbPrefix = [[ACPublishTagS3Service fileNamePrefix] retain];
	thumbFilename = [[ACPublishTagS3Service filename] retain];
	largePrefix = [[ACPublishTagS3Service fileNamePrefix] retain];
	largeFilename = [[ACPublishTagS3Service filename] retain];
	GDRelease(publishLarge);
	publishLarge = [[ACPublishTagRackspaceService service] retain];
	[publishLarge setComplete:GDCreateCallback(self,onLargePostedToStorageComplete)];
	[publishLarge setFault:GDCreateCallback(self,onLargePostedToStorageFault)];
	[publishLarge uploadFile:largeFilename prefix:largePrefix data:jpg container:@"graffcity"];
	//[publishLarge sendFileToBucket:larges asFileName:largeFilename withPrefix:largePrefix];
	GDRelease(publishThumb);
	publishThumb = [[ACPublishTagRackspaceService service] retain];
	[publishThumb setComplete:GDCreateCallback(self,onThumbPostedToStorageComplete)];
	[publishThumb setFault:GDCreateCallback(self,onThumbPostedToStorageFault)];
	[publishThumb uploadFile:thumbFilename prefix:thumbPrefix data:jpgt container:@"graffcity"];
	//[publishThumb sendFileToBucket:thumbs asFileName:thumbFilename withPrefix:thumbPrefix];
}

- (void) executePostToServerWithImageUpload {
	geoTries = 3;
	NSString * username = [user username];
	NSString * password = [user password];
	CLLocationDirection orientation = [app currentHeading];
	CLLocationDegrees latitude = [app currentLatitude];
	CLLocationDegrees longitude = [app currentLongitude];
	UIImage * image = [self compositeImage];
	UIImage * thumb = [[ACStickerManager sharedInstance] createThumbnail:image withWidth:130 andHeight:78];
	NSData * jpg = UIImageJPEGRepresentation(image,.75);
	NSData * jpgt = UIImageJPEGRepresentation(thumb,.85);
	GDRelease(publishService);
	publishService = [[ACPublishTagService serviceWithUsername:username password:password latitude:latitude longitude:longitude orientation:orientation jpgData:jpg andThumbData:jpgt] retain];
	[publishService setThoroughfare:[app thoroughfare] subThoroughfare:[app subThoroughfare]];
	[publishService setLocality:[app locality] subLocality:[app subLocality]];
	[publishService setAdministrativeArea:[app administrativeArea] subAdministrativeArea:[app subAdministrativeArea]];
	[publishService setPostalCode:[app postalcode] andCountry:[app country]];
	[publishService setFinished:GDCreateCallback(self,onPublishFinished) andFailed:GDCreateCallback(self,onPublishFailed)];
	[publishService sendAsync];
}

- (void) executePostToServerWithImageRecordNames {
	geoTries = 3;
	NSString * username = [user username];
	NSString * password = [user password];
	CLLocationDirection orientation = [app currentHeading];
	CLLocationDegrees latitude = [app currentLatitude];
	CLLocationDegrees longitude = [app currentLongitude];
	NSString * lg = [NSString stringWithFormat:@"%@-%@",largePrefix,largeFilename];
	NSString * th = [NSString stringWithFormat:@"%@-%@",thumbPrefix,thumbFilename];
	GDRelease(publishService);
	publishService = [[ACPublishTagService serviceWithUsername:username password:password latitude:latitude longitude:longitude orientation:orientation jpgName:lg andThumbName:th] retain];
	[publishService setThoroughfare:[app thoroughfare] subThoroughfare:[app subThoroughfare]];
	[publishService setLocality:[app locality] subLocality:[app subLocality]];
	[publishService setAdministrativeArea:[app administrativeArea] subAdministrativeArea:[app subAdministrativeArea]];
	[publishService setPostalCode:[app postalcode] andCountry:[app country]];
	[publishService setFinished:GDCreateCallback(self,onPublishFinished) andFailed:GDCreateCallback(self,onPublishFailed)];
	[publishService sendAsync];
}

- (void) onGEOComplete {
	[self executePostToStorage];
	//[self executePostToServerWithImageUpload];
	//[self executePostToServerWithImageRecordNames];
}

- (void) onGEOFailed {
	if(geoTries > 0) {
		geoTries--;
		[app updateGEOInformationWithCompleteCallback:GDCreateCallback(self,onGEOComplete) andFailCallback:GDCreateCallback(self,onGEOFailed)];
		return;
	}
	[self executePostToStorage];
	//[self executePostToServerWithImageUpload];
	//[self executePostToServerWithImageRecordNames];
}

- (void) onLargePostedToStorageComplete {
	triedPostLarge = true;
	postedLargeToStorage = true;
	[self checkStorage];
}

- (void) onLargePostedToStorageFault {
	triedPostLarge = true;
	postedLargeToStorage = false;
	[self checkStorage];
}

- (void) onThumbPostedToStorageComplete {
	triedPostThumb = true;
	postedThumbToStorage = true;
	[self checkStorage];
}

- (void) onThumbPostedToStorageFault {
	triedPostThumb = true;
	postedThumbToStorage = false;
	[self checkStorage];
}

- (void) checkStorage {
	if(!triedPostLarge || !triedPostThumb) return;
	if(postedThumbToStorage && postedLargeToStorage) {
		[self executePostToServerWithImageRecordNames];
	} else {
	}
}

- (void) tryFacebook {
	if(isFacebooking) {
		[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(shareToFacebook:) userInfo:nil repeats:false];
	}
}

- (void) onPublishFinished {
	[app hideServiceIndicator];
	[ACProfileInfoService expireCache];
	[ACListTagsService expireCache];
	[ACSettingsMyGallery expireCachedGalleryData];
	if(!isFacebooking) [ACAlerts showSavedToServer];
	[saveOptions removeFromSuperview];
	NSDictionary * data = [publishService response];
	GDRelease(imageNameForFacebook);
	imageNameForFacebook = [[data objectForKey:@"large"] copy];
	[self tryFacebook];
	GDRelease(publishService);
}

- (void) shareToFacebook:(NSString *) imageName {
	NSString * shareBase = ACRoutesFacebookShare;
	NSString * shareURL = [shareBase stringByAppendingString:imageNameForFacebook];
	//NSString * s3Path = [ACServicesHelper getS3FilepathFromFileName:imageNameForFacebook];
	NSString * fullURL = [ACFacebookShareURL stringByAppendingString:shareURL];
	//NSString * fullURL = [ACFacebookShareURL stringByAppendingString:s3Path];
	NSURL * url = [[NSURL alloc] initWithString:fullURL];
	[[UIApplication sharedApplication] openURL:url];
	[url release];
}

- (void) onPublishFailed {
	[app hideServiceIndicator];
	[publishService showFaultMessage];
	GDRelease(publishService);
}

- (IBAction) saveToPhotoAlbum:(id) sender {
	UIImage * saveImage = [self compositeImage];
	UIImageWriteToSavedPhotosAlbum(saveImage,nil,nil,nil);
	[ACAlerts showSavedToPhotoAlbum];
	[saveOptions removeFromSuperview];
}

- (IBAction) saveSticker:(id) sender {
	NSString * stickerName = [ACStickerManager stickerName];
	[[ACStickerManager sharedInstance] saveSticker:tag.image forName:stickerName];
	[ACAlerts showSavedToStickers];
	[self hide];
}

- (IBAction) back:(id) sender {
	
	[[app views] popViewControllerAnimated:false];
	[self hide];
}

- (IBAction) selectBackground {
	selectedImage = background;
	[self checkButtonStates];
}

- (IBAction) moveBackground {
	selectedImage = background;
	backgroundSelected = true;
	[self checkButtonStates];
	[toggleMoveMode removeFromSuperview];
}

- (IBAction) moveTag {
	selectedImage = tag;
	backgroundSelected = false;
	[self checkButtonStates];
	[toggleMoveMode removeFromSuperview];
}

- (IBAction) selectTag {
	selectedImage = tag;
	[self checkButtonStates];
}

- (IBAction) showMove {
	if([blendingModes superview]) [blendingModes removeFromSuperview];
	CGRect frame = [toggleMoveMode frame];
	frame.origin.x = 152;
	frame.origin.y = 45;
	[toggleMoveMode setFrame:frame];
	if([toggleMoveMode superview]) [toggleMoveMode removeFromSuperview];
	else [[self view] addSubview:toggleMoveMode];
}

- (void) checkButtonStates {
	if(selectedImage == tag) {
		selectBackgroundButton.isActive = true;
		selectTagButton.isActive = false;
	} else {
		selectBackgroundButton.isActive = false;
		selectTagButton.isActive = true;
	}
}

- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event {
	if(blendingEnabled) blendView.hidden = true;
	NSSet * allTouches = [event allTouches];
	if([allTouches count] == 1) isRotating = false;
}

- (void) touchesMoved:(NSSet *) touches withEvent:(UIEvent *) event {
	isMoving = true;
	NSSet * allTouches = [event allTouches];
	if([allTouches count] > 1) {
		UITouch * touch1 = [[allTouches allObjects] objectAtIndex:0];
		UITouch * touch2 = [[allTouches allObjects] objectAtIndex:1];
		CGPoint prev1 = [touch1 previousLocationInView: [self view]];
		CGPoint prev2 = [touch2 previousLocationInView: [self view]];
		CGPoint location1 = [touch1 locationInView: [self view]];
		CGPoint location2 = [touch2 locationInView: [self view]];
		//rotate and scale
		startScale = GetDistanceBetweenPoints(prev1, prev2);
		startRotation = GetAngleBetweenPoints(prev1, prev2);
		[self rotateAndScale:location1 andPoint:location2];
	} else {
		UITouch * touch1 = [[allTouches allObjects] objectAtIndex:0];
		CGPoint prev1 = [touch1 previousLocationInView: [self view]];
		CGPoint location = [touch1 locationInView: [self view]];
		if(!isSkewing) {
			startPositionOffset = CGPointMake(selectedImage.center.x - prev1.x, selectedImage.center.y - prev1.y);
			[self moveImage:location];
		} else {
			[self skewImage:prev1 andPoint:location];
		}
	}
}

- (void) touchesEnded:(NSSet *) touches withEvent:(UIEvent *) event {
	if(blendingEnabled) {
		[blendView update];
		blendView.hidden = false;
	}
	NSSet * allTouches = [event allTouches];
	UITouch * touch1 = [[allTouches allObjects] objectAtIndex:0];
	if([touch1 tapCount] == 2 && [allTouches count] == 1 && !isMoving) selectedImage = background;	
	else if([allTouches count] == 1 && !isMoving) selectedImage = tag;
	if([allTouches count] == 1) isMoving = false;
}

- (void) toggleSelection {
	if(backgroundSelected) {
		selectedImage = tag;
		backgroundSelected = false;
	} else {
		selectedImage = background;
		backgroundSelected = true;
	}
	[self checkButtonStates];
}

- (IBAction) toggleSaveOptions {
	if([saveOptions superview]) [saveOptions removeFromSuperview];
	else [[self view] addSubview:saveOptions];
	//saveOptions.hidden = !saveOptions.hidden;
}

- (void) moveImage:(CGPoint) pos {
	selectedImage.center = CGPointMake(pos.x + startPositionOffset.x, pos.y + startPositionOffset.y);
}

- (IBAction) nextBlendMode {
	if(blendingEnabled) [blendView nextBlendMode];
}

- (IBAction) showBlendingModes {
	if([toggleMoveMode superview]) [toggleMoveMode removeFromSuperview];
	if([blendingModes superview]) {
		[blendingModes removeFromSuperview];
		return;
	}
	CGRect frame = [blendingModes frame];
	frame.origin.x = 152;
	frame.origin.y = 45;
	[blendingModes setFrame:frame];
	[[self view] addSubview:blendingModes];
}

- (void) rotateAndScale:(CGPoint) start andPoint:(CGPoint) end {
	//new scale
	float newScale = GetDistanceBetweenPoints(start, end);
	float sizeDifference = (newScale / startScale);
	selectedImage.transform = CGAffineTransformScale(selectedImage.transform, sizeDifference, sizeDifference);
	startScale = newScale;
	//new rotation
	float newRotation = GetAngleBetweenPoints(start, end);
	float offset = newRotation - startRotation;
	selectedImage.transform = CGAffineTransformRotate(selectedImage.transform, DegreesToRadians(offset) );
	startRotation = newRotation;
}

- (void) skewImage:(CGPoint) start andPoint:(CGPoint) end {
	rotX += end.x - start.x;
	rotY += end.y - start.y;
	transform3D = CATransform3DIdentity;
	transform3D = CATransform3DTranslate (transform3D, 0, 0, tag.image.size.width);
	transform3D = CATransform3DRotate(transform3D, DegreesToRadians(rotX), 0, 1, 0);
	transform3D = CATransform3DRotate(transform3D, DegreesToRadians(rotY), 1, 0, 0);
	tag.layer.transform = transform3D;
}

- (void) userAccountPromptDidSuccessfullyLogin:(UserAccountPrompt *) _prompt {
	[NSTimer scheduledTimerWithTimeInterval:.4 target:self selector:@selector(postToServer:) userInfo:nil repeats:false];
	[self dismissModalViewControllerAnimated:true];
}

- (void) prepareFrame {
	
}

- (void) viewDidGoIn {
	
}

- (void) viewDidGoOut {
	GDRelease(imageNameForFacebook);
	GDRelease(background);
	GDRelease(tag);
}

-(void) unloadView {
	
}

- (void) viewDidUnload {
	GDRelease(background);
	GDRelease(tag);
}

- (void) dealloc {
	GDRelease(imageNameForFacebook);
	GDRelease(blendingModes);
	GDRelease(blendView);
	GDRelease(tag);
	GDRelease(background);
	GDRelease(containerView);
	GDRelease(saveToServer);
	GDRelease(saveToAlbum);
	GDRelease(saveOptions);
	GDRelease(publishService);
	GDRelease(delegate);
	GDRelease(prompt);
	selectedImage = nil;
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACTagLayout");
	#endif
    [super dealloc];
}

@end
