
#import <Foundation/Foundation.h>
#import "ACDripAccelData.h"
#import "angles.h"

@interface ACDrip : NSObject {
	float x;
	float y;
	float length;
	bool completed;
}

@property (nonatomic,assign) float x;
@property (nonatomic,assign) float y;
@property (nonatomic,assign) bool completed;

+ (void) setDripLength:(float) dripLength;
- (void) update;

@end
