
#import "ACTools.h"
#import "ACAppController.h"

static float __defaultBrushSize = 1.5;
static float __defaltDripLength = 50;
static NSString * __defaultBrushName = @"drawing_brush_chisel_tip_marker.png";

@implementation ACTools
@synthesize container;
@synthesize colorSelectedTabs;
@synthesize brushesView;
@synthesize optionsView;
@synthesize colorView;
@synthesize tabsContainer;
@synthesize brushSelectedTabs;
@synthesize brushOptionsSelectedTabs;
@synthesize thinTip;
@synthesize orangeFat;
@synthesize nyFat;
@synthesize chiselTip;
@synthesize mediumTip;
@synthesize shoePolish;
@synthesize streaker;
@synthesize brushesScroller;
@synthesize defaultsPrefix;
@synthesize delegate;
@synthesize selectedBrush;
@synthesize dripSwitch;
@synthesize size;
@synthesize dripLength;
@synthesize optionsScroller;

+ (void) setDefaultBrushSize:(float) brushSize {
	__defaultBrushSize = brushSize;
}

+ (void) setDefaultBrushFileName:(NSString *) brushName {
	[__defaultBrushName release];
	__defaultBrushName = [brushName retain];
}

+ (void) setDefaultDripLength:(float) dripLength {
	__defaltDripLength = dripLength;
}

- (id) initWithNibName:(NSString *) nibNameOrNil bundle:(NSBundle *) nibBundleOrNil {
	if(!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) return nil;
	defaults = [NSUserDefaults standardUserDefaults];
	colorPicker = [[ACColorPicker alloc] initWithNibName:@"ColorPicker" bundle:nil];
	return self;
}

- (IBAction) back {
	//[defaults synchronize];
	[colorPicker saveColors];
	[self.view removeFromSuperview];
}

- (IBAction) brushes {
	if([brushesView superview])return;
	[container removeAllSubviews];
	[tabsContainer removeAllSubviews];
	[tabsContainer addSubview:brushSelectedTabs];
	[container addSubview:brushesView];
}

- (IBAction) options {
	if([optionsView superview]) return;
	[tabsContainer removeAllSubviews];
	[container removeAllSubviews];
	[tabsContainer addSubview:brushOptionsSelectedTabs];
	[container addSubview:optionsView];
}

- (IBAction) colors {
	if([colorView superview]) return;
	[tabsContainer removeAllSubviews];
	[container removeAllSubviews];
	[tabsContainer addSubview:colorSelectedTabs];
	[container addSubview:colorView];
	[container addSubview:[colorPicker view]];
}

- (IBAction) sizeChanged {
	float sz = [size value];
	[defaults setFloat:sz forKey:sizeSliderValueKey];
	[defaults setBool:true forKey:hasSetDefaultsForSizeKey];
	[delegate tools:self didChangeBrushSize:sz];
}

- (IBAction) dripSwitchChanged {
	Boolean v = [dripSwitch isOn];
	[defaults setBool:v forKey:dripSwitchStateKey];
	[defaults setBool:true forKey:hasSetDefaultsForDripStateKey];
	[delegate tools:self didToggleDripState:v];
}

- (IBAction) dripLengthChanged {
	float dl = [dripLength value];
	[defaults setFloat:dl forKey:dripSliderValueKey];
	[defaults setBool:true forKey:hasSetDefaultsForDripLengthKey];
	[delegate tools:self didChangeDripLength:dl];
}

- (Boolean) dripStateValue {
	Boolean s = true;
	if(dripSwitch) s = [dripSwitch isOn];
	else if([defaults boolForKey:hasSetDefaultsForDripStateKey]) s = [defaults boolForKey:dripSwitchStateKey];
	return s;
}

- (float) dripLengthValue {
	float len = __defaltDripLength;
	if(dripLength) len = [dripLength value];
	else if([defaults boolForKey:hasSetDefaultsForDripLengthKey]) len = [defaults floatForKey:dripSliderValueKey];
	return len;
}

- (float) brushSizeValue {
	float s = __defaultBrushSize;
	if(size) s = [size value];
	else if([defaults boolForKey:hasSetDefaultsForSizeKey]) s = [defaults floatForKey:sizeSliderValueKey];	
	return s;
}

- (NSString *) brushNameValue {
	NSString * n = [defaults objectForKey:defaultsBrushNameKey];
	if(!n) n = __defaultBrushName;
	return n;
}

- (UIColor *) selectedColor {
	return [colorPicker selectedUIColor];
}

- (void) setDefaultsPrefix:(NSString *) prefix {
	if(![defaultsPrefix isEqual:prefix]) {
		[defaultsPrefix release];
		defaultsPrefix = [prefix copy];
		[defaultsSelectedBrushIdKey release];
		[dripSwitchStateKey release];
		[sizeSliderValueKey release];
		[dripSliderValueKey release];
		[hasSetDefaultsForSizeKey release];
		[defaultsBrushNameKey release];
		[hasSetDefaultsForDripStateKey release];
		defaultsSelectedBrushIdKey = [[NSString stringWithFormat:@"%@%@",defaultsPrefix,@".Tools.SelectedBrushId"] retain];
		dripSwitchStateKey = [[NSString stringWithFormat:@"%@%@",defaultsPrefix,@".Tools.DripSwitchState"] retain];
		dripSliderValueKey = [[NSString stringWithFormat:@"%@%@",defaultsPrefix,@".Tools.DripLengthSliderValue"] retain];
		sizeSliderValueKey = [[NSString stringWithFormat:@"%@%@",defaultsPrefix,@".Tools.SizeSliderValue"] retain];
		hasSetDefaultsForDripLengthKey = [[NSString stringWithFormat:@"%@%@",defaultsPrefix,@".Tools.HasSetDripLengthDefault"] retain];
		hasSetDefaultsForDripStateKey = [[NSString stringWithFormat:@"%@%@",defaultsPrefix,@".Tools.HasSetDripStateDefault"] retain];
		hasSetDefaultsForSizeKey = [[NSString stringWithFormat:@"%@%@",defaultsPrefix,@".Tools.HasSetAnySizeDefaults"] retain];
		defaultsBrushNameKey = [[NSString stringWithFormat:@"%@%@",defaultsPrefix,@".Tools.SelectedBrushName"] retain];
	}
}

- (void) setSelectedBrush:(ACBrushButton *) brush {
	if(selectedBrush != brush) {
		if(selectedBrush) {
			[selectedBrush deselect];
			[selectedBrush release];
		}
		selectedBrush = [brush retain];
		[defaults setInteger:[selectedBrush brushId] forKey:defaultsSelectedBrushIdKey];
		[defaults setObject:[selectedBrush brushName] forKey:defaultsBrushNameKey];
		if(![selectedBrush brushName]) {
			NSLog(@"WARNING: The {brushName} property is not set.");
		} else {
			//[defaults synchronize];
			[delegate tools:self didSelectBrush:[selectedBrush brushName]];
		}
	}
}

- (void) colorPicker:(ACColorPicker *) colorPicker pickedColor:(UIColor *)color {
	[delegate tools:self didChangeColor:color];
}

- (void) setBrushIds {
	ACBrushButton * button;
	NSInteger count = [brushes count];
	NSInteger i = 0;
	for(;i<count;i++) {
		button = [brushes objectAtIndex:i];
		[button setBrushId:i];
	}
}

- (void) updateBrushNames {
	[chiselTip setBrushName:@"drawing_brush_chisel_tip_marker.png"];
	[mediumTip setBrushName:@"drawing_brush_medium_tip.png"];
	[shoePolish setBrushName:@"drawing_brush_shoe_polish_marker.png"];
	[thinTip setBrushName:@"drawing_brush_small_tip_marker.png"];
	[mediumTip setBrushName:@"drawing_brush_standard_spraypaint_tip.png"];
	[nyFat setBrushName:@"drawing_brush_standard_ny_fat.png"];
	[orangeFat setBrushName:@"drawing_brush_standard_orange_fat_cap.png"];
	[streaker setBrushName:@"drawing_brush_streaker.png"];
}

- (void) updateComponents {
	UIImage * slide_thumb_out = [UIImage imageNamed:@"slider_thumb_out.png"];
	UIImage * slide_track_min = [UIImage imageNamed:@"slider_track_min.png"];
	UIImage * slide_track_max = [UIImage imageNamed:@"slider_track_max.png"];
	Boolean hasSetDripState = [defaults boolForKey:hasSetDefaultsForDripStateKey];
	Boolean hasSetDripLength = [defaults boolForKey:hasSetDefaultsForDripLengthKey];
	[size setThumbImage:slide_thumb_out forState:UIControlStateNormal];
	[size setThumbImage:slide_thumb_out forState:UIControlStateHighlighted];
	[size setMinimumTrackImage:slide_track_min forState:UIControlStateNormal];
	[size setMaximumTrackImage:slide_track_max forState:UIControlStateNormal];
	[dripLength setThumbImage:slide_thumb_out forState:UIControlStateNormal];
	[dripLength setThumbImage:slide_thumb_out forState:UIControlStateHighlighted];
	[dripLength setMinimumTrackImage:slide_track_min forState:UIControlStateNormal];
	[dripLength setMaximumTrackImage:slide_track_max forState:UIControlStateNormal];
	if(hasSetDripState) {
		Boolean dripSwitchState = [defaults boolForKey:dripSwitchStateKey];
		[dripSwitch setOn:dripSwitchState animated:false];
	}
	if(hasSetDripLength) {
		float drip_length = [defaults floatForKey:dripSliderValueKey];
		[dripLength setValue:drip_length];
	}
	float size_value = [defaults floatForKey:sizeSliderValueKey];
	[size setValue:size_value];
}

- (void) updateSelectedButton {
	NSInteger selectedId = [defaults integerForKey:defaultsSelectedBrushIdKey];
	ACBrushButton * button = [brushes objectAtIndex:selectedId];
	[button select];
	[self setSelectedBrush:button];
}

- (void) viewDidLoad {
	app = [ACAppController sharedInstance];
	brushes = [[NSMutableArray alloc] initWithObjects:thinTip,orangeFat,nyFat,chiselTip,mediumTip,shoePolish,streaker,nil];
	[self updateComponents];
	[self setBrushIds];
	[self updateBrushNames];
	[self updateSelectedButton];
	[container addSubview:brushesView];
	[tabsContainer addSubview:brushSelectedTabs];
	[colorPicker setDelegate:self];
}

- (void) unloadView {
	[self viewDidUnload];
}

- (void) viewDidUnload {
	[super viewDidUnload];
}

- (void) didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void) dealloc {
	GDRelease(defaultsPrefix);
	GDRelease(colorSelectedTabs);
	GDRelease(brushes);
	GDRelease(tabsContainer);
	GDRelease(brushSelectedTabs);
	GDRelease(brushOptionsSelectedTabs);
	GDRelease(container);
	GDRelease(brushesView);
	GDRelease(optionsView);
	GDRelease(colorView);
	GDRelease(size);
	GDRelease(dripLength);
	GDRelease(dripSwitch);
	GDRelease(optionsScroller);
	GDRelease(brushesScroller);
	GDRelease(selectedBrush);
	GDRelease(thinTip);
	GDRelease(orangeFat);
	GDRelease(nyFat);
	GDRelease(chiselTip);
	GDRelease(mediumTip);
	GDRelease(shoePolish);
	GDRelease(streaker);
	GDRelease(colorPicker);
	GDRelease(defaultsSelectedBrushIdKey);
	GDRelease(sizeSliderValueKey);
	GDRelease(dripSwitchStateKey);
	GDRelease(dripSliderValueKey);
	GDRelease(hasSetDefaultsForDripStateKey);
	GDRelease(hasSetDefaultsForDripLengthKey);
	GDRelease(hasSetDefaultsForSizeKey);
	GDRelease(defaultsBrushNameKey);
	[(id)delegate release];
	delegate = nil;
	app = nil;
	defaults = nil;
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACTools");
	#endif
	[super dealloc];
}

@end
