
#import "ACColorPicker.h"

@implementation ACColorPicker
@synthesize selectedColor;
@synthesize colorSample0;
@synthesize colorSample1;
@synthesize colorSample2;
@synthesize colorSample3;
@synthesize colorSample4;
@synthesize colorSample5;
@synthesize dragger;
@synthesize delegate;
@synthesize label;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if(!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) return nil;
	NSString * home = NSHomeDirectory();
	savedColorsPath = [[home stringByAppendingPathComponent:@"Documents/colorcache"] retain];
	NSFileManager * fileman = [NSFileManager defaultManager];
	NSString * colorsdir = [home stringByAppendingPathComponent:@"Documents"];
	[fileman createDirectoryAtPath:colorsdir withIntermediateDirectories:true attributes:nil error:nil];
	[self loadColors];
	return self;
}

- (void) saveColors {
	if(!colorSample0) return;
	NSFileManager * fileman = [NSFileManager defaultManager];
	NSString * home = NSHomeDirectory();
	NSString * colorsdir = [home stringByAppendingPathComponent:@"Documents"];
	[fileman createDirectoryAtPath:colorsdir withIntermediateDirectories:true attributes:nil error:nil];
	NSMutableArray * colors = [NSMutableArray array];
	[colors addObject:[selectedColor color]];
	[colors addObject:[colorSample0 color]];
	[colors addObject:[colorSample1 color]];
	[colors addObject:[colorSample2 color]];
	[colors addObject:[colorSample3 color]];
	[colors addObject:[colorSample4 color]];
	[colors addObject:[colorSample5 color]];
	NSMutableData * d = [NSMutableData data];
	NSKeyedArchiver * ar = [[NSKeyedArchiver alloc] initForWritingWithMutableData:d];
	[ar encodeObject:colors forKey:@"ACColorPicker.colors"];
	[ar finishEncoding];
	[d writeToFile:savedColorsPath atomically:true];
	[ar release];
	ar = nil;
}

- (void) loadColors {
	NSFileManager * fm = [NSFileManager defaultManager];
	if(![fm fileExistsAtPath:savedColorsPath]) return;
	NSData * d = [NSData dataWithContentsOfFile:savedColorsPath];
	NSKeyedUnarchiver * ua = [[NSKeyedUnarchiver alloc] initForReadingWithData:d];
	NSArray * colors = [ua decodeObjectForKey:@"ACColorPicker.colors"];
	[ua finishDecoding];
	[ua release];
	ua = nil;
	if(colorSample0) {
		[selectedColor setColor:[colors objectAtIndex:0]];
		[colorSample0 setColor:[colors objectAtIndex:1]];
		[colorSample1 setColor:[colors objectAtIndex:2]];
		[colorSample2 setColor:[colors objectAtIndex:3]];
		[colorSample3 setColor:[colors objectAtIndex:4]];
		[colorSample4 setColor:[colors objectAtIndex:5]];
		[colorSample5 setColor:[colors objectAtIndex:6]];
	}
	if(!rawSelectedColor) rawSelectedColor = [[colors objectAtIndex:0] retain];
}

- (UIColor *) selectedUIColor {
	if(!colorSample0 && rawSelectedColor) return rawSelectedColor;
	return [UIColor redColor];
}

- (void) colorSampleTouchedDown:(ACColorSample *) colorSample {
	[self colorChanged:colorSample.color];
}

- (void) saveSwatch:(NSString *) swatchKey withColor:(UIColor *) color {
	
}

- (void) colorSampleTouchedUp:(ACColorSample *) colorSample {
	
}

- (void) colorWheel:(ACColorWheel *) colorWheel pickedColor:(UIColor *) color {
	[self colorChanged:color];
}

- (void) colorChanged:(UIColor *) c {
	[selectedColor setColor:c];
	[delegate colorPicker:self pickedColor:c];
}

- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event {
	UITouch * touch = [touches anyObject];
	CGPoint location = [touch locationInView:[self view]];
	if([self detectCollisionOfView:selectedColor withPoint:location]) {
		draggingSelectedColor = true;
		dragger.hidden = false;
		dragger.color = selectedColor.color;
		dragger.center = location;
	}
}

- (void) touchesMoved:(NSSet *) touches withEvent:(UIEvent *) event{
	if(draggingSelectedColor) {
		UITouch * touch = [[event touchesForView:self.view] anyObject];
		CGPoint location = [touch locationInView:self.view];
		dragger.center = location;
	}
}

- (void) touchesEnded:(NSSet *) touches withEvent:(UIEvent *) event{
	if(draggingSelectedColor) {
		CGPoint collidePoint = dragger.center;
		if([self detectCollisionOfView:colorSample0 withPoint:collidePoint]) {
			[self updateColorIn:colorSample0 withColor:selectedColor.color];
		} else if([self detectCollisionOfView:colorSample1 withPoint:collidePoint]) {
			[self updateColorIn:colorSample1 withColor:selectedColor.color];
		} else if([self detectCollisionOfView:colorSample2 withPoint:collidePoint]) {
			[self updateColorIn:colorSample2 withColor:selectedColor.color];
		} else if([self detectCollisionOfView:colorSample3 withPoint:collidePoint]) {
			[self updateColorIn:colorSample3 withColor:selectedColor.color];
		} else if([self detectCollisionOfView:colorSample4 withPoint:collidePoint]) {
			[self updateColorIn:colorSample4 withColor:selectedColor.color];
		} else if([self detectCollisionOfView:colorSample5 withPoint:collidePoint]) {
			[self updateColorIn:colorSample5 withColor:selectedColor.color];
		}
	}
	draggingSelectedColor = false;
	dragger.hidden = true;
}
		
- (bool) detectCollisionOfView:(UIView*) view withPoint:(CGPoint) point {
	CGRect boundBox = view.frame;
	return point.x > boundBox.origin.x && point.y > boundBox.origin.y && point.x < boundBox.origin.x + boundBox.size.width && point.y < boundBox.origin.y + boundBox.size.height;
}

- (void) updateColorIn:(ACColorSample *) colorSample withColor:(UIColor *) c {
	CGColorRef cgColor = [c CGColor];
	UIColor * newColor = [UIColor colorWithCGColor:cgColor];
	colorSample.color = newColor;
}

- (void) unloadView {
	[self setView:nil];
}

- (void) viewDidGoIn {
	
}

- (void) viewDidGoOut {
	
}

- (void) viewDidLoad {
	selectedColorOrigin = [selectedColor center];
	NSFileManager * fileman = [NSFileManager defaultManager];
	if([fileman fileExistsAtPath:savedColorsPath]) {
		[self loadColors];
	} else {
		selectedColor.color = [UIColor whiteColor];
		colorSample0.color = [UIColor redColor];
		colorSample1.color = [UIColor blueColor];
		colorSample2.color = [UIColor greenColor];
		colorSample3.color = [UIColor orangeColor];
		colorSample4.color = [UIColor purpleColor];
		colorSample5.color = [UIColor yellowColor];
	}
	colorSample5.delegate = self;
	colorSample4.delegate = self;
	colorSample3.delegate = self;
	colorSample2.delegate = self;
	colorSample1.delegate = self;
	colorSample0.delegate = self;
	dragger.hidden = true;
	[FontLabelHelper setFont_AgencyFBBold_ForLabel:label withPointSize:22];
	[colorWheel setDelegate:self];
}

- (void) viewDidUnload {
    [super viewDidUnload];
}

- (void) dealloc {
	[(id)delegate release];
	delegate = nil;
	//GDRelease(selectedColorStr);
	GDRelease(rawSelectedColor);
	GDRelease(selectedColor);
	GDRelease(savedColorsPath);
	GDRelease(colorWheel);
	GDRelease(selectedColor);
	GDRelease(colorSample0);
	GDRelease(colorSample1);
	GDRelease(colorSample2);
	GDRelease(colorSample3);
	GDRelease(colorSample4);
	GDRelease(colorSample5);
	GDRelease(dragger);
	draggingSelectedColor = false;
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACColorPicker");
	#endif
    [super dealloc];
}

@end
