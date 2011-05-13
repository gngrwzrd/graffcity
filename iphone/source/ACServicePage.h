
#import <Foundation/Foundation.h>
#import "macros.h"

@interface ACServicePage : NSObject {
	long available;
	NSNumber * offset;
	NSNumber * pagesize;
	NSNumber * totalRows;
}

@property (nonatomic,retain) NSNumber * offset;
@property (nonatomic,retain) NSNumber * pagesize;
@property (nonatomic,retain) NSNumber * totalRows;
@property (nonatomic,assign) long available;

- (NSNumber *) limit;
- (void) stepOffset;
- (void) reset;
- (BOOL) hasMore;
- (void) addMoreAvailable:(int) more;

@end
