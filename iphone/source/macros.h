
#import <UIKit/UIKit.h>

/**
 * Random macros and functions
 */
#define GDRelease(x) do { \
	if((x)==nil){break;} \
	[(x) release];(x)=nil;}while(0);

/*if(x) { \
	[(x) release]; \
	(x) = nil; \
	printf("GDRelease!\n"); \
  } \*/

#define GDPrintClockDifference(label,c1,c2) \
	printf("%s: %f\n",label,(float)(c2-c1)/CLOCKS_PER_SEC);

/**
 * Print an UIAcceleration object
 */
NS_INLINE void GDPrintUIAcceleration(UIAcceleration * acceleration) {
	NSLog(@"UIAcceleration(x:%g, y:%g, z:%g)",[acceleration x],[acceleration y],[acceleration z]);
}

/**
 * Print a CGPoint
 */
NS_INLINE void GDPrintCGPoint(CGPoint point) {
	NSLog(@"CGPoint(x:%g,y:%g)",point.x,point.y);
}

/**
 * Print a CGRect
 */
NS_INLINE void GDPrintCGRect(CGRect rect) {
	NSLog(@"CGRect(x:%g,y:%g,w:%g,h:%g)",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
}

#define GDCreateCallback(t,s) ([GDCallback callbackWithTarget:(t) andAction:(@selector(s))])
