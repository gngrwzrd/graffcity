
#import <UIKit/UIKit.h>
#import "UIColor-Expanded.h"
#import "ACColorWheel.h"
#import "ACColorSample.h"
#import "FontLabel.h"
#import "FontLabelHelper.h"
#import "macros.h"

@class ACColorPicker;

@protocol ACColorPickerDelegate
- (void) colorPicker:(ACColorPicker *)colorPicker pickedColor:(UIColor*)color;
@end

@interface ACColorPicker : UIViewController <ACColorWheelDelegate, ACColorSampleDelegate>{
	Boolean draggingSelectedColor;
	CGPoint selectedColorOrigin;
	NSObject <ACColorPickerDelegate> * delegate;
	UIColor * rawSelectedColor;
	NSString * savedColorsPath;
	ACColorWheel * colorWheel;
	ACColorSample * selectedColor;
	ACColorSample * colorSample0;
	ACColorSample * colorSample1;
	ACColorSample * colorSample2;
	ACColorSample * colorSample3;
	ACColorSample * colorSample4;
	ACColorSample * colorSample5;
	ACColorSample * dragger;
	FontLabel * label;
}

@property (nonatomic,retain) id delegate;
@property (nonatomic,retain) ACColorSample * selectedColor;
@property (nonatomic,retain) IBOutlet FontLabel * label;
@property (nonatomic,retain) IBOutlet ACColorSample * colorSample0;
@property (nonatomic,retain) IBOutlet ACColorSample * colorSample1;
@property (nonatomic,retain) IBOutlet ACColorSample * colorSample2;
@property (nonatomic,retain) IBOutlet ACColorSample * colorSample3;
@property (nonatomic,retain) IBOutlet ACColorSample * colorSample4;
@property (nonatomic,retain) IBOutlet ACColorSample * colorSample5;
@property (nonatomic,retain) IBOutlet ACColorSample * dragger;

- (void) updateColorIn:(ACColorSample*) colorSample withColor:(UIColor*) c;
- (void) saveSwatch:(NSString*) swatchKey withColor:(UIColor*) color;
- (void) colorChanged:(UIColor*) c;
- (void) saveColors;
- (void) loadColors;
- (bool) detectCollisionOfView:(UIView*) view withPoint:(CGPoint) point;
- (UIColor *) selectedUIColor;

@end
