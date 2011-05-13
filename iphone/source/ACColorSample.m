#import "ACColorSample.h"

@implementation ACColorSample
@synthesize color;
@synthesize delegate;

- (id) initWithCoder:(NSCoder *)aDecoder {
	if(!(self = [super initWithCoder:aDecoder])) return nil;
	[self setColor:[UIColor whiteColor]];
	return self;
}

- (void) setColor:(UIColor *) c {
	if(whiteImage == nil) whiteImage = self.image;
	self.image = [self colorizeImage:whiteImage color:c];
	GDRelease(color);
	color = [c retain];
}

- (UIColor *) color {
	return color;
}

- (UIImage *) colorizeImage:(UIImage *) baseImage color:(UIColor *) theColor {
    UIGraphicsBeginImageContext(baseImage.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, baseImage.CGImage);
    [theColor set];
    CGContextFillRect(ctx, area);
    CGContextRestoreGState(ctx);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextDrawImage(ctx, area, baseImage.CGImage);
	UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event{
	[delegate colorSampleTouchedDown:self];
}

- (void) touchesEnded:(NSSet *) touches withEvent:(UIEvent *) event{
	[delegate colorSampleTouchedUp:self];
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACColorSample");
	#endif
	GDRelease(color);
	GDRelease(whiteImage);
	[(id)delegate release];
	delegate = nil;
    [super dealloc];
}

@end
