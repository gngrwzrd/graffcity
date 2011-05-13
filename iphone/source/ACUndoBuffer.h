
#import <Foundation/Foundation.h>

@interface ACUndoBuffer : NSObject {
	unsigned char * buffer;
	CGRect rect;
	CGRect trans;
}

@property (nonatomic,assign) unsigned char * buffer;
@property (nonatomic,assign) CGRect rect;
@property (nonatomic,assign) CGRect trans;

- (id) initWithBuffer:(unsigned char*)b andRect:(CGRect)r andTransform:(CGRect)t;

@end
