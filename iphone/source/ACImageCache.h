
#import <Foundation/Foundation.h>
#import "CacheGlobals.h"
#import "macros.h"

@interface ACImageCache : NSObject {
	NSString * imagepath;
	NSFileManager * fileman;
	NSMutableDictionary * memcache;
}

@property (nonatomic,copy) NSString * imagepath;

+ (ACImageCache *) sharedInstance;
- (void) cacheImage:(UIImage *) image withName:(NSString *) name;
- (Boolean) isImageCachedWithName:(NSString *) name;
- (Boolean) isImageMemcachedWithName:(NSString *) name;
- (NSString *) getPathForFile:(NSString *) name;
- (UIImage *) imageNamed:(NSString *) name;

@end
