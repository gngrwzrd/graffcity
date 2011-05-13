
#import <UIKit/UIKit.h>
#import "UIView+Additions.h"
#import "ACBrushButton.h"
#import "ACToolsDelegate.h"
#import "ACDrip.h"
#import "ACColorWheel.h"
#import "ACColorPicker.h"

@class ACAppController;

@interface ACTools : UIViewController <ACColorPickerDelegate>{
	id <ACToolsDelegate> delegate;
	NSString * defaultsPrefix;
	NSString * defaultsSelectedBrushIdKey;
	NSString * sizeSliderValueKey;
	NSString * dripSwitchStateKey;
	NSString * dripSliderValueKey;
	NSString * hasSetDefaultsForDripLengthKey;
	NSString * hasSetDefaultsForDripStateKey;
	NSString * hasSetDefaultsForSizeKey;
	NSString * defaultsBrushNameKey;
	NSMutableArray * brushes;
	NSUserDefaults * defaults;
	UIView * tabsContainer;
	UIView * brushSelectedTabs;
	UIView * brushOptionsSelectedTabs;
	UIView * colorSelectedTabs;
	UIView * container;
	UIView * brushesView;
	UIView * optionsView;
	UIView * colorView;
	UISlider * size;
	UISlider * dripLength;
	UISwitch * dripSwitch;
	UIScrollView * optionsScroller;
	UIScrollView * brushesScroller;
	ACBrushButton * selectedBrush;
	ACBrushButton * thinTip;
	ACBrushButton * orangeFat;
	ACBrushButton * nyFat;
	ACBrushButton * chiselTip;
	ACBrushButton * mediumTip;
	ACBrushButton * shoePolish;
	ACBrushButton * streaker;
	ACColorPicker * colorPicker;
	ACAppController * app;
}

@property (nonatomic,retain) id delegate;
@property (nonatomic,retain) IBOutlet UIScrollView * brushesScroller;
@property (nonatomic,retain) IBOutlet UIView * container;
@property (nonatomic,retain) IBOutlet UIView * tabsContainer;
@property (nonatomic,retain) IBOutlet UIView * brushSelectedTabs;
@property (nonatomic,retain) IBOutlet UIView * brushOptionsSelectedTabs;
@property (nonatomic,retain) IBOutlet UIView * colorSelectedTabs;
@property (nonatomic,retain) IBOutlet UIView * brushesView;
@property (nonatomic,retain) IBOutlet UIView * optionsView;
@property (nonatomic,retain) IBOutlet UIView * colorView;
@property (nonatomic,retain) ACBrushButton * selectedBrush;
@property (nonatomic,retain) IBOutlet ACBrushButton * thinTip;
@property (nonatomic,retain) IBOutlet ACBrushButton * orangeFat;
@property (nonatomic,retain) IBOutlet ACBrushButton * nyFat;
@property (nonatomic,retain) IBOutlet ACBrushButton * chiselTip;
@property (nonatomic,retain) IBOutlet ACBrushButton * mediumTip;
@property (nonatomic,retain) IBOutlet ACBrushButton * shoePolish;
@property (nonatomic,retain) IBOutlet ACBrushButton * streaker;
@property (nonatomic,copy) NSString * defaultsPrefix;
@property (nonatomic,retain) IBOutlet UISlider * dripLength;
@property (nonatomic,retain) IBOutlet UISwitch * dripSwitch;
@property (nonatomic,retain) IBOutlet UISlider * size;
@property (nonatomic,retain) IBOutlet UIScrollView * optionsScroller;

/**
 * Set this for default brush size (no brush size is available in 
 * user defaults yet).
 */
+ (void) setDefaultBrushSize:(float) brushSize;

/**
 * Set this for default brush name when there's nothing available in
 * user defaults yet. by default it's set to "Chisel_Tip_Marker.png"
 */
+ (void) setDefaultBrushFileName:(NSString *) brushName;

/**
 * Set this for default drip length, when there's nothing available in
 * user defaults yet.  by default it's 3.
 */
+ (void) setDefaultDripLength:(float) dripLength;

- (void) setBrushIds;
- (void) updateComponents;
- (void) updateSelectedButton;
- (void) updateBrushNames;
- (void) unloadView;
- (IBAction) back;
- (IBAction) brushes;
- (IBAction) options;
- (IBAction) colors;
- (IBAction) sizeChanged;
- (IBAction) dripSwitchChanged;
- (IBAction) dripLengthChanged;
- (Boolean) dripStateValue;
- (float) dripLengthValue;
- (float) brushSizeValue;
- (NSString *) brushNameValue;
- (UIColor *) selectedColor;

@end
