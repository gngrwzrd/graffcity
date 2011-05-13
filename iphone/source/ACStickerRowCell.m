
#import "ACStickerRowCell.h"

@implementation ACStickerRowCell
@synthesize index;
@synthesize imageView;
@synthesize onCellPressed;
@synthesize onDeleteSwipe;
@synthesize deleteButton;
@synthesize deleteButtonView;

- (id) initWithCoder:(NSCoder *) aDecoder {
	if(!(self = [super initWithCoder:aDecoder])) return nil;
	onDeleteSwipe = [GDCreateCallback(self,__onDeleteSwipe) retain];
	return self;
}

- (void) __onDeleteSwipe {
	if(!onDeleteSwipe) return;
	[self addSubview:deleteButtonView];
}

- (void) reset {
	[deleteButtonView removeFromSuperview];
	[imageView setImage:nil];
}

- (void) viewDidLoad {
	[deleteButton setOnDelete:onDeleteSwipe];
}

- (void) renderWithData:(ACStickerRowData *) _data {
	[imageView setImage:[_data stickerThumbImage]];
}

- (IBAction) cellPressed {
	[onCellPressed setArgs:[NSArray arrayWithObjects:self,nil]];
	[onCellPressed execute];
}

- (IBAction) onDeletePressed {
	[onDeleteSwipe setArgs:[NSArray arrayWithObjects:self,nil]];
	[onDeleteSwipe execute];
}

- (IBAction) onCancel {
	[deleteButtonView removeFromSuperview];
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACStickerRowCell");
	#endif
	GDRelease(deleteButton);
	GDRelease(deleteButtonView);
	GDRelease(onCellPressed);
	GDRelease(onDeleteSwipe);
	GDRelease(imageView);
	[super dealloc];
}

@end
