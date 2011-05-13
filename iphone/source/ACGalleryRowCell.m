
#import "ACGalleryRowCell.h"
#import "ACGalleryRowCellData.h"

@implementation ACGalleryRowCell
@synthesize thumbImageView;
@synthesize activity;
@synthesize titleLabel;
@synthesize tagCountLabel;
@synthesize tagsLabel;
@synthesize ratingView;
@synthesize imageLoader;
@synthesize streetLabel;
@synthesize cityLabel;
@synthesize infoContainer;
@synthesize exploreInfoView;
@synthesize galleryInfoView;
@synthesize streetLabel2;
@synthesize cityLabel2;
@synthesize ratingView2;
@synthesize onCellPressedCallback;
@synthesize index;
@synthesize data;
@synthesize hitButton;
@synthesize onDeleteSwiped;
@synthesize deleteButtonView;

- (id) initWithCoder:(NSCoder *)aDecoder {
	if(!(self = [super initWithCoder:aDecoder])) return self;
	__onDeleteSwiped = [GDCreateCallback(self,_onDeleteSwiped) retain];
	return self;
}

- (void) viewDidLoad {
	[hitButton setOnDelete:__onDeleteSwiped];
}

- (void) _onDeleteSwiped {
	if(!onDeleteSwiped) return;
	[self addSubview:deleteButtonView];
}

- (IBAction) onCellPress {
	[onCellPressedCallback setArgs:[NSArray arrayWithObjects:self,nil]];
	[onCellPressedCallback execute];
}

- (IBAction) onDeletePressed {
	if(!onDeleteSwiped) return;
	[deleteButtonView removeFromSuperview];
	[onDeleteSwiped setArgs:[NSArray arrayWithObjects:self,nil]];
	[onDeleteSwiped execute];
}

- (IBAction) onCancelPressed {
	[deleteButtonView removeFromSuperview];
}

- (void) reset {
	[imageLoader release];
	imageLoader = nil;
	[thumbImageView setImage:nil];
	[self addSubview:activity];
	[deleteButtonView removeFromSuperview];
	[exploreInfoView removeFromSuperview];
	[galleryInfoView removeFromSuperview];
}

- (void) renderGalleryInfoViewWithData:(ACGalleryRowCellData *) d {
	if(!d) return;
	[self setData:d];
	[infoContainer addSubview:galleryInfoView];
	[FontLabelHelper setFont_AgencyFBBold_ForLabel:cityLabel2 withPointSize:13];
	[FontLabelHelper setFont_AgencyFBBold_ForLabel:streetLabel2 withPointSize:13];
	NSString * city = [d subAdministrativeArea];
	NSString * street = [d thoroughfare];
	NSNull * nl = [NSNull null];
	if((id)city == nl) city = @"";
	if((id)street == nl) street = @"";
	if([city isEqual:@"None"]) city = @"";
	if([street isEqual:@"None"]) street = @"";
	[cityLabel2 setText:[city uppercaseString]];
	[streetLabel2 setText:[street uppercaseString]];
	[ratingView2 setStarImage:[UIImage imageNamed:@"rating_star2_half.png"] forState:kSCRatingViewHalfSelected];
	[ratingView2 setStarImage:[UIImage imageNamed:@"rating_star2_cyan.png"] forState:kSCRatingViewHighlighted];
	[ratingView2 setStarImage:[UIImage imageNamed:@"rating_star2_hot.png"] forState:kSCRatingViewHot];
	[ratingView2 setStarImage:[UIImage imageNamed:@"rating_star2_cyan.png"] forState:kSCRatingViewSelected];
	[ratingView2 setStarImage:[UIImage imageNamed:@"rating_star2_cyan.png"] forState:kSCRatingViewUserSelected];
	[ratingView2 setStarImage:[UIImage imageNamed:@"rating_star2_white.png"] forState:kSCRatingViewNonSelected];
	[ratingView2 setUserRating:[d rating]];
	[ratingView2 setUserInteractionEnabled:false];
	if([self imageLoader]) [imageLoader cancel];
	ACImageLoader * il = [[ACImageLoader alloc] initWithImageView:thumbImageView andActivityView:activity];
	[self setImageLoader:il];
	NSString * fileToLoad;
	NSString * urlToLoad;
	if([d thumbFilename] && (id)[d thumbFilename] != nl) fileToLoad = [d thumbFilename];
	else fileToLoad = [d largeFilename];
	if([d thumbURL] && (id)[d thumbURL] != nl) urlToLoad = [d thumbURL];
	else urlToLoad = [d largeURL];
	[il setFilename:fileToLoad];
	[il setImageURLString:urlToLoad];
	[il load];
	[il release];
}

- (void) renderExploreInfoViewWithData:(ACGalleryRowCellData *) d {
	[self setData:d];
	[infoContainer addSubview:exploreInfoView];
	[FontLabelHelper setFont_AgencyFBBold_ForLabel:titleLabel withPointSize:22];
	[FontLabelHelper setFont_AgencyFBBold_ForLabel:tagCountLabel withPointSize:13];
	[FontLabelHelper setFont_AgencyFBBold_ForLabel:tagsLabel withPointSize:13];
	[FontLabelHelper setFont_AgencyFBBold_ForLabel:cityLabel withPointSize:13];
	[FontLabelHelper setFont_AgencyFBBold_ForLabel:streetLabel withPointSize:13];
	[titleLabel setText:[[d title] uppercaseString]];
	NSString * city = [d subAdministrativeArea];
	NSString * street = [d thoroughfare];
	NSNull * nl = [NSNull null];
	if((id)city == nl) city = @"";
	if((id)street == nl) street = @"";
	if([city isEqual:@"None"]) city = @"";
	if([street isEqual:@"None"]) street = @"";
	[cityLabel setText:[city uppercaseString]];
	[streetLabel setText:[street uppercaseString]];
	[tagCountLabel setText:[[d tagCount] stringValue]];
	if([[d tagCount] intValue] == 1) [tagsLabel setText:@"TAG"];
	else [tagsLabel setText:@"TAGS"];
	[ratingView setStarImage:[UIImage imageNamed:@"rating_star5_half.png"] forState:kSCRatingViewHalfSelected];
	[ratingView setStarImage:[UIImage imageNamed:@"rating_star5_cyan.png"] forState:kSCRatingViewHighlighted];
	[ratingView setStarImage:[UIImage imageNamed:@"rating_star5_hot.png"] forState:kSCRatingViewHot];
	[ratingView setStarImage:[UIImage imageNamed:@"rating_star5_cyan.png"] forState:kSCRatingViewSelected];
	[ratingView setStarImage:[UIImage imageNamed:@"rating_star5_cyan.png"] forState:kSCRatingViewUserSelected];
	[ratingView setStarImage:[UIImage imageNamed:@"rating_star5_white.png"] forState:kSCRatingViewNonSelected];
	[ratingView setUserRating:[d rating]];
	[ratingView setUserInteractionEnabled:false];
	CGSize tagCountSize2 = [[tagCountLabel text] sizeWithZFont:[tagCountLabel zFont]];
	CGRect tagsLabelFrame = [tagsLabel frame];
	CGRect tagCountLabelFrame = [tagCountLabel frame];
	CGRect tagsLabelNewFrame = CGRectMake(tagCountLabelFrame.origin.x + tagCountSize2.width + 4, tagsLabelFrame.origin.y, tagsLabelFrame.size.width, tagsLabelFrame.size.height);
	[tagsLabel setFrame:tagsLabelNewFrame];
	if([self imageLoader]) [imageLoader cancel];
	ACImageLoader * il = [[ACImageLoader alloc] initWithImageView:thumbImageView andActivityView:activity];
	NSString * fileToLoad;
	NSString * urlToLoad;
	if([d thumbFilename] && (id)[d thumbFilename] != nl) fileToLoad = [d thumbFilename];
	else fileToLoad = [d largeFilename];
	if([d thumbURL] && (id)[d thumbURL] != nl) urlToLoad = [d thumbURL];
	else urlToLoad = [d largeURL];
	[il setFilename:fileToLoad];
	[il setImageURLString:urlToLoad];
	[il load];
	[il release];
}

- (void) dealloc {
	[infoContainer removeAllSubviews];
	GDRelease(__onDeleteSwiped);
	GDRelease(onDeleteSwiped);
	GDRelease(hitButton);
	GDRelease(onCellPressedCallback);
	GDRelease(data);
	GDRelease(activity);
	GDRelease(thumbImageView);
	GDRelease(titleLabel);
	GDRelease(cityLabel);
	GDRelease(streetLabel);
	GDRelease(tagCountLabel);
	GDRelease(tagsLabel);
	GDRelease(ratingView);
	GDRelease(imageLoader);
	GDRelease(exploreInfoView);
	GDRelease(infoContainer);
	GDRelease(galleryInfoView);
	GDRelease(cityLabel2);
	GDRelease(streetLabel2);
	GDRelease(ratingView2);
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACGalleryRowCell");
	#endif
	[super dealloc];
}

@end
