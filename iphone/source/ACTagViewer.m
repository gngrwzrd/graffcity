
#import "ACTagViewer.h"
#import "ACAppController.h"
#import "ACRateService.h"
#include <Openssl/md5.h>

@implementation ACTagViewer
@synthesize data;
@synthesize showUsername;
@synthesize navControls;
@synthesize topControls;
@synthesize tagContainer;
@synthesize controlsContainer;
@synthesize selectedItem;
@synthesize ratingView;
@synthesize pager;
@synthesize usernameLabel;
@synthesize streetLabel;
@synthesize cityLabel;
@synthesize alreadyRated;
@synthesize selectedUsableDataIndex;
@synthesize shareControls;
@synthesize facebookButton;

- (IBAction) back {
	[[app views] popViewControllerAnimated:false];
}

- (IBAction) share {
	if([shareControls superview]) [shareControls removeFromSuperview];
	else {
		[shareControls setCenter:CGPointMake(160,220)];
		[[self view] addSubview:shareControls];
	}
	ACGalleryRowCellData * si = [self selectedItem];
	bool hideFacebook = showUsername;
	if([[si uid] isEqualToNumber:[user uid]]) hideFacebook = false;
	if([[si uid] intValue] == 0 && [[user uid] intValue] == 0) hideFacebook = true;
	if(hideFacebook) {
		[facebookButton removeFromSuperview];
		CGRect sf = [shareControls frame];
		[shareControls setFrame:CGRectMake(sf.origin.x,sf.origin.y+10, sf.size.width, sf.size.height)];
	}
}

- (IBAction) saveToCameraRoll {
	NSUInteger selectedIndex = [self selectedItemIndex];
	ACTagViewerItem * item = (ACTagViewerItem *)[items objectAtIndex:selectedIndex];
	UIImage * img = [[item imageview] image];
	UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);
	[ACAlerts showSavedToPhotoAlbum];
}

- (IBAction) email {
	NSUInteger selectedIndex = [self selectedItemIndex];
	ACTagViewerItem * item = (ACTagViewerItem *)[items objectAtIndex:selectedIndex];
	UIImage * img = [[item imageview] image];
	NSData * jpg = UIImageJPEGRepresentation(img,.75);
	MFMailComposeViewController * mail = [[[MFMailComposeViewController alloc] init] autorelease];
	[mail setSubject:@"Tag From Graff City"];
	[mail addAttachmentData:jpg mimeType:@"image/jpg" fileName:@"graffcitytag.jpg"];
	[self presentModalViewController:mail animated:true];
	[mail setMailComposeDelegate:self];
}

- (IBAction) facebook {
	id seli = [self selectedItem];
	NSString * shareBase = ACRoutesFacebookShare;
	NSString * shareURL = [shareBase stringByAppendingString:[seli largeFilename]];
	//NSString * s3Path = [ACServicesHelper getS3FilepathFromFileName:[seli largeFilename]];
	NSString * fullURL = [ACFacebookShareURL stringByAppendingString:shareURL];
	//NSString * fullURL = [ACFacebookShareURL stringByAppendingString:s3Path];
	NSURL * url = [[NSURL alloc] initWithString:fullURL];
	[[UIApplication sharedApplication] openURL:url];
	[url release];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[controller dismissModalViewControllerAnimated:true];
}

- (IBAction) prev {
	canHideControls = false;
	NSUInteger selectedIndex = [self selectedItemIndex];
	NSUInteger minItems = 0;
	NSUInteger nextItem = ((selectedItem - 1) < 0) ? 0 : selectedIndex - 1;
	if(selectedIndex == minItems) return;
	[self setSelectedItem:[usedData objectAtIndex:nextItem]];
	[self scrollToPage:nextItem];
}

- (IBAction) next {
	canHideControls = false;
	NSUInteger selectedIndex = [self selectedItemIndex];
	NSUInteger maxItems = [usedData count] - 1;
	NSUInteger nextItem = selectedIndex + 1;
	if(selectedIndex == maxItems) return;
	[self setSelectedItem:[usedData objectAtIndex:nextItem]];
	[self scrollToPage:nextItem];
}

- (void) updateSelectedItem {
	CGPoint contentOffset = [tagContainer contentOffset];
	NSUInteger selectedIndex = ceil(contentOffset.x / 320);
	[self setSelectedItem:[usedData objectAtIndex:selectedIndex]];
	[self updateRatingView];
	[self updateLabels];
	ACTagViewerItem * item = (ACTagViewerItem *)[items objectAtIndex:selectedIndex];
	[item load];
	if(selectedIndex > 0) {
		item = [items objectAtIndex:selectedIndex-1];
		[item load];
	}
	if(selectedIndex < [items count]-1) {
		item = [items objectAtIndex:selectedIndex+1];
		[item load];
	}
}

- (void) updateLabels {
	NSNull * nl = [NSNull null];
	NSString * street = [selectedItem thoroughfare];
	NSString * city = [selectedItem subAdministrativeArea];
	if((id)street == nl) street = nil;
	if((id)city == nl) city = nil;
	if([city isEqual:@"None"]) city = nil;
	if([street isEqual:@"None"]) street = nil;
	CGRect fr = [usernameLabel frame];
	if(showUsername) {
		if(!city || !street) {
			[cityLabel setHidden:true];
			[streetLabel setHidden:true];
			[usernameLabel setFrame:CGRectMake(17,30,fr.size.width,fr.size.height)];
		} else {
			[cityLabel setHidden:false];
			[streetLabel setHidden:false];
			[cityLabel setText:[city uppercaseString]];
			[streetLabel setText:[street uppercaseString]];
			[usernameLabel setFrame:CGRectMake(17,1,fr.size.width,fr.size.height)];
		}
		[usernameLabel setHidden:false];
		[usernameLabel setText:[[selectedItem title] uppercaseString]];
	} else {
		[usernameLabel setHidden:true];
		if(!city || !street) {
			[cityLabel setHidden:true];
			[streetLabel setHidden:true];
		} else {
			[cityLabel setHidden:false];
			[streetLabel setHidden:false];
			[cityLabel setText:[city uppercaseString]];
			[streetLabel setText:[street uppercaseString]];
		}
	}
}

- (void) updateRatingView {
	[ratingView setUserInteractionEnabled:true];
	[ratingView setRating:[selectedItem rating]];
	[alreadyRated removeFromSuperview];
	if([ratingCache hasRatedTagId:[selectedItem tagId]]) {
		[ratingView setUserInteractionEnabled:false];
		[navControls addSubview:alreadyRated];
	}
}

- (void) scrollToPage:(NSUInteger) page {
	CGRect position = CGRectMake(320*page,0,320,480);
	[tagContainer scrollRectToVisible:position animated:!firstPage];
	if(firstPage) [self updateSelectedItem];
	firstPage = false;
}

- (void) scrollViewWantsControlsShown:(ACTagViewerScrollView *) scrollView {
	if([navControls superview]) return;
	canHideControls = true;
	[[self view] addSubview:navControls];
	[[self view] addSubview:topControls];
}

- (void) scrollViewDidBeginTouches:(ACTagViewerScrollView *) scrollView {
	canHideControls = true;
}

- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	canHideControls = true;
	[self updateSelectedItem];
}

- (void) scrollViewDidMoveTouches:(ACTagViewerScrollView *) scrollView {
	canHideControls = true;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *) scrollView {
	canHideControls = true;
	[self updateSelectedItem];
}

- (void) scrollViewDidScroll:(UIScrollView *) scrollView {
	if(canHideControls) {
		[topControls removeFromSuperview];
		[navControls removeFromSuperview];
	}
}

- (NSUInteger) selectedItemIndex {
	if(!selectedItem) return 0;
	ACGalleryRowCellData * item;
	int i = 0;
	int count = [usedData count];
	for(;i<count;i++) {
		item = [usedData objectAtIndex:i];
		if(item == selectedItem) return i;
	}
	return 0;
}

- (void) reload {
	int i = 0;
	float h = 480;
	float w = [data count] * 320;
	GDRelease(items);
	GDRelease(usedData);
	usedData = [[NSMutableArray alloc] init];
	items = [[NSMutableArray alloc] init];
	NSUInteger pagecount = [data count];
	CGSize size = CGSizeMake(w,h);
	CGRect sframe = [tagContainer frame];
	[tagContainer setPagingEnabled:true];
	[tagContainer setContentSize:size];
	[tagContainer setShowsVerticalScrollIndicator:false];
	[tagContainer setShowsHorizontalScrollIndicator:false];
	[tagContainer setScrollsToTop:false];
	[tagContainer setDelegate:self];
	ACGalleryRowCellData * itemdata = nil;
	ACTagViewerItem * item = nil;
	for(;i<pagecount;i++) {
		itemdata = [data objectAtIndex:i];
		if(!itemdata) {
			pagecount -= 1;
			size.width -= 320;
			continue;
		}
		if(![itemdata respondsToSelector:@selector(celltype)]) {
			pagecount -= 1;
			size.width -= 320;
			continue;
		}
		if([itemdata celltype] != kCellTypeExplore && [itemdata celltype] != kCellTypeGallery) {
			pagecount -= 1;
			size.width -= 320;
			continue;
		}
		[usedData addObject:itemdata];
		item = [[ACTagViewerItem alloc] initWithNibName:@"TagViewerItem" bundle:nil];
		[items addObject:item];
		[item release];
		[item setImageURL:[itemdata largeURL]];
		[item setFilename:[itemdata largeFilename]];
		[item loadView];
		[item viewDidLoad];
		[[item scroller] setDelegate:self];
		[[item view] setFrame:CGRectMake(sframe.size.width * i,0,320,480)];
		[tagContainer addSubview:[item view]];
	}
	NSUInteger selectedPageIndex = [self selectedItemIndex];
	[tagContainer setContentSize:size];
	[pager setNumberOfPages:pagecount];
	[pager setCurrentPage:selectedPageIndex];
	[self scrollToPage:selectedPageIndex];
}

- (void) checkFor0Selection {
	NSUInteger i = [self selectedItemIndex];
	if(i == 0) [self updateSelectedItem];
}

- (void) buildImageset {
	
}

- (void) ratingView:(SCRatingView *) ratingView didChangeRatingFrom:(CGFloat) previousRating to:(CGFloat) rating {
	
}

- (void) ratingView:(SCRatingView *) ratingView didChangeUserRatingFrom:(NSInteger) previousUserRating to:(NSInteger) userRating {
	if(showingRating) return;
	showingRating = true;
	sendRating = userRating;
	NSString * message = [NSString stringWithFormat:@"Rate this tag a %i?",userRating];
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:nil];
	[alert addButtonWithTitle:@"Yes"];
	[alert show];
	[alert release];
	showingRating = true;
}

- (void) alertView:(UIAlertView *) alertView didDismissWithButtonIndex:(NSInteger) buttonIndex {
	showingRating = false;
	if(buttonIndex == 0) return;
	NSNumber * nr = [NSNumber numberWithInt:ceil([ratingView userRating])];
	[ratingCache setRating:nr forTagId:[selectedItem tagId]];
	[ratingView setRating:[selectedItem rating]];
	[self performRating];
	sendRating = 1;
}

- (void) performRating {
	[app showServiceIndicator];
	GDRelease(rateService);
	int r = ceil(sendRating);
	rateService = [[ACRateService serviceWithTagId:[selectedItem tagId] andRating:r] retain];
	[rateService setFinished:GDCreateCallback(self,onRateFinished) andFailed:GDCreateCallback(self,onRateFailed)];
	[rateService sendAsync];
}

- (void) onRateFinished {
	[ratingCache save];
	[ratingView setUserInteractionEnabled:false];
	[app hideServiceIndicator];
	[navControls addSubview:alreadyRated];
	GDRelease(rateService);
}

- (void) onRateFailed {
	[app hideServiceIndicator];
	[rateService showFaultMessage];
	GDRelease(rateService);
}

- (void) prepareFrame {
	
}

- (void) viewDidGoIn {
	if(!user) user = [ACUserInfo sharedInstance];
	[self reload];
	[self updateRatingView];
}

- (void) viewDidGoOut {
	
}

- (void) viewDidLoad {
	app = [ACAppController sharedInstance];
	ratingCache = [[ACRatingCache alloc] init];
	firstPage = true;
	[ratingView setStarImage:[UIImage imageNamed:@"rating_star4_half.png"] forState:kSCRatingViewHalfSelected];
	[ratingView setStarImage:[UIImage imageNamed:@"rating_star4_cyan.png"] forState:kSCRatingViewHighlighted];
	[ratingView setStarImage:[UIImage imageNamed:@"rating_star4_hot.png"] forState:kSCRatingViewHot];
	[ratingView setStarImage:[UIImage imageNamed:@"rating_star4_cyan.png"] forState:kSCRatingViewSelected];
	[ratingView setStarImage:[UIImage imageNamed:@"rating_star4_cyan.png"] forState:kSCRatingViewUserSelected];
	[ratingView setStarImage:[UIImage imageNamed:@"rating_star4_gray.png"] forState:kSCRatingViewNonSelected];
	[ratingView setDelegate:self];
	CGRect navFrame = [navControls frame];
	CGRect newNavFrame = CGRectMake(0,480 - navFrame.size.height,320,navFrame.size.height);
	[navControls setFrame:newNavFrame];
	[FontLabelHelper setFont_AgencyFBRegular_ForLabel:usernameLabel withPointSize:50];
	[FontLabelHelper setFont_AgencyFBBold_ForLabel:cityLabel withPointSize:15];
	[FontLabelHelper setFont_AgencyFBBold_ForLabel:streetLabel withPointSize:15];
}

- (void) unloadView {
	[self setView:nil];
}

- (void) viewDidUnload {
	GDRelease(data);
	GDRelease(usedData);
	GDRelease(items);
	GDRelease(shareControls);
	GDRelease(navControls);
	GDRelease(controlsContainer);
	GDRelease(tagContainer);
	GDRelease(ratingView);
	GDRelease(selectedItem);
	GDRelease(pager);
	GDRelease(ratingCache);
	GDRelease(usernameLabel);
	GDRelease(cityLabel);
	GDRelease(streetLabel);
	GDRelease(alreadyRated);
	app = nil;
	user = nil;
	[super viewDidUnload];
}

- (void) didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void) dealloc {
	[self unloadView];
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACTagViewer");
	#endif
	[super dealloc];
}

@end
