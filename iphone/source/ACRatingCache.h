
#import <Foundation/Foundation.h>
#import "macros.h"
#import "ACUserInfo.h"

@interface ACRatingCache : NSObject {
	
}

- (void) load;
- (void) save;
- (void) setRating:(NSNumber *) rating forTagId:(NSNumber *) tagId;
- (BOOL) hasRatedTagId:(NSNumber *) tagId;

@end
