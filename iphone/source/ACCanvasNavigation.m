#import "ACCanvasNavigation.h"

@implementation ACCanvasNavigation

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	ledSize = 3;
	UIImage *ledImage = [UIImage imageNamed:@"dot.png"];
	led = [[UIImageView alloc] initWithImage:ledImage];
	[self addSubview:led];
	self.opaque = false;
    return self;
}

- (void)drawRect:(CGRect)rect{
	CGContextRef context = UIGraphicsGetCurrentContext(); 
	
	// fill the backing
	CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.25);
	CGContextFillRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
	
	// draw a red stroke
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0); 
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0.0, 0.0);// begin
    CGContextAddLineToPoint(context, self.frame.size.width, 0);
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
    CGContextAddLineToPoint(context, 0, self.frame.size.height); 
    CGContextClosePath(context); // end
    CGContextSetLineWidth(context, 2.0); 
    CGContextStrokePath(context); 
}

- (void)updatePosition:(CGPoint)position{
	float xPos = position.x * (self.frame.size.width - ledSize);
	float yPos = position.y * (self.frame.size.height - ledSize);
	led.frame = CGRectMake(xPos, yPos, ledSize, ledSize);
}

- (void)dealloc {
	[led release];
    [super dealloc];
}


@end
