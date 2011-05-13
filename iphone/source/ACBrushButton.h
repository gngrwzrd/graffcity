
#import <UIKit/UIKit.h>

@class ACTools;

@interface ACBrushButton : UIView {
	NSString * brushName;
	UIImageView * iconBG;
	UIImageView * iconHighlight;
	UIImageView * icon;
	UIButton * button;
	NSInteger brushId;
	ACTools * toolsOwner;
}

@property (nonatomic,retain) IBOutlet NSString * brushName;
@property (nonatomic,retain) IBOutlet UIImageView * iconBG;
@property (nonatomic,retain) IBOutlet UIImageView * iconHighlight;
@property (nonatomic,retain) IBOutlet UIImageView * icon;
@property (nonatomic,retain) IBOutlet UIButton * button;
@property (nonatomic,assign) NSInteger brushId;
@property (nonatomic,retain) IBOutlet ACTools * toolsOwner;

- (void) deselect;
- (void) select;
- (IBAction) selected;

@end
