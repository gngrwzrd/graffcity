
#import "ARCell.h"

@implementation ARCell
@synthesize tagImageView;
@synthesize ratingView;
@synthesize label1;
@synthesize label2;
@synthesize tagImageBackgroundView;
@synthesize delegate;
@synthesize data;
@synthesize activity;

- (IBAction) touchedDownInside {
	[delegate arCellTouchedUpInside:self];
}

- (void) viewDidLoad {
	if(data) {
		[label1 setText:[[data title] uppercaseString]];
		[label2 setText:[NSString stringWithFormat:@"%i TAGS",[[data tagCount] intValue]]];
		if([[data tagCount] intValue] == 1) [label2 setText:[NSString stringWithFormat:@"%i TAG",[[data tagCount] intValue]]];
		else [label2 setText:[NSString stringWithFormat:@"%i TAGS",[[data tagCount] intValue]]];
		[ratingView setStarImage:[UIImage imageNamed:@"rating_star3_half.png"] forState:kSCRatingViewHalfSelected];
		[ratingView setStarImage:[UIImage imageNamed:@"rating_star3_black.png"] forState:kSCRatingViewHighlighted];
		[ratingView setStarImage:[UIImage imageNamed:@"rating_star3_hot.png"] forState:kSCRatingViewHot];
		[ratingView setStarImage:[UIImage imageNamed:@"rating_star3_black.png"] forState:kSCRatingViewSelected];
		[ratingView setStarImage:[UIImage imageNamed:@"rating_star3_black.png"] forState:kSCRatingViewUserSelected];
		[ratingView setStarImage:[UIImage imageNamed:@"rating_star3_gray.png"] forState:kSCRatingViewNonSelected];
		[ratingView setRating:[data rating]];
	}
	loader = [[ACImageLoader alloc] initWithImageView:tagImageView andActivityView:activity];
	[loader setImageURLString:[data largeURL]];
	[loader setFilename:[data largeFilename]];
	[loader load];
}

- (void) unloadView {
	[self setView:nil];
}

- (void) viewDidUnload {
	[super viewDidUnload];
}

- (void) dealloc {	
	[self unloadView];
	GDRelease(loader);
	GDRelease(tagImageBackgroundView);
	GDRelease(tagImageView);
	GDRelease(ratingView);
	GDRelease(label1);
	GDRelease(label2);
	GDRelease(activity);
	GDRelease(data);
	GDRelease(delegate);
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ARCell");
	#endif
	[super dealloc];
}

@end
