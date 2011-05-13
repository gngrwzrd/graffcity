
#import "ACBlendModeView.h"

/*
 // PDF Blend Modes
 @"Normal",
 @"Multiply",
 @"Screen",
 @"Overlay",
 @"Darken",
 @"Lighten",
 @"ColorDodge",
 @"ColorBurn",
 @"SoftLight",
 @"HardLight",
 @"Difference",
 @"Exclusion",
 @"Hue",
 @"Saturation",
 @"Color",
 @"Luminosity"
 */

@implementation ACBlendModeView
@synthesize index;

- (id) initWithFrame:(CGRect) frame {
	if(!(self = [super initWithFrame:frame])) return nil;
	blendMode = 0;
	modeLengths = 16;
	index = 0;
    return self;
}

- (int) blendModeIndex {
	return index;
}

- (void) compositeBackground:(UIImageView *) bg withTag:(UIImageView *) tag {
	background = [bg retain];
	grafitti = [tag retain];
	[self setNeedsDisplay];
}

- (void) nextBlendMode {
	index += 1;
	if(index >= modeLengths) index = 0;
	blendMode = index;
	[self setNeedsDisplay];
}

- (void) previousBlendMode {
	index -= 1;
	if(index < 0) index = modeLengths - 1;
	blendMode = index;
	[self setNeedsDisplay];
}

- (void) update {
	[self setNeedsDisplay];
}

- (void) setIndexAndUpdate:(int) idx {
	index = idx;
	[self update];
}

- (void) drawRect:(CGRect) rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, CGRectMake(0, 0, 320, 480));
	CGContextSaveGState(context);
	CGPoint bc = background.center; //draw bg
	float a = background.image.size.width / 2;
	float b = background.image.size.height / 2;
	CGContextTranslateCTM(context,bc.x,bc.y);
	CGContextConcatCTM(context,background.transform);
	CGContextTranslateCTM(context,-a,-b);
	[background.image drawAtPoint:CGPointMake(0,0) blendMode:kCGBlendModeNormal alpha:1.0];
	CGContextRestoreGState(context); //draw tag
	CGPoint gc = grafitti.center;
	float c = grafitti.image.size.width / 2;
	float d = grafitti.image.size.height / 2;
	CGContextTranslateCTM(context,gc.x,gc.y);
	CGContextConcatCTM(context,grafitti.transform);
	CGContextTranslateCTM(context,-c,-d);
	[grafitti.image drawAtPoint:CGPointMake(0, 0) blendMode:index alpha:1.0];
}

- (void) dealloc {
	GDRelease(background);
	GDRelease(grafitti);
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACBlendModeView");
	#endif
    [super dealloc];
}

@end
