
#import <Foundation/Foundation.h>

@interface ACAccelerometerTarget : NSObject {
	id target;
	SEL selector;
}

@property (nonatomic,readonly) id target;
@property (nonatomic,readonly) SEL selector;

- (id) initWithTarget:(id) _target andSelector:(SEL) _selector;

@end
