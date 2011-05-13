#import <Foundation/Foundation.h>
#import "ACDrip.h"
#import "ACDripAccelData.h"


@interface ACDripManager : NSObject {
	NSMutableArray *drips;
	NSTimer *timer;
	bool isDripping;
}

@property (nonatomic, retain) NSMutableArray *drips; 
@property (nonatomic, assign) bool isDripping;

- (void)randomCheckAtX:(float)x andY:(float)y;
- (void)addDripAtX:(float)x andY:(float)y;
- (void)stopDrips;
- (void)updateDrips;

@end
