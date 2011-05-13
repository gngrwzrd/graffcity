
#import "ACServicePage.h"

static NSNumber * limit;

@implementation ACServicePage
@synthesize offset;
@synthesize pagesize;
@synthesize totalRows;
@synthesize available;

- (id) init {
	if(!(self = [super init])) return nil;
	if(!limit) limit = [[NSNumber numberWithInt:25] retain];
	pagesize = [[NSNumber numberWithInt:25] retain];
	offset = [[NSNumber numberWithInt:0] retain];
	totalRows = [[NSNumber numberWithInt:0] retain];
	available = 0;
	return self;
}

- (void) reset {
	GDRelease(totalRows);
	GDRelease(offset);
	GDRelease(pagesize);
	available = 0;
	pagesize = [[NSNumber numberWithInt:25] retain];
	offset = [[NSNumber numberWithInt:0] retain];
	totalRows = [[NSNumber numberWithInt:0] retain];
}

- (void) stepOffset {
	int n = [offset intValue] + [limit intValue];
	[offset release];
	offset = [[NSNumber numberWithInt:n] retain];
}

- (BOOL) hasMore {
	return (totalRows - available) > 0;
}

- (void) addMoreAvailable:(int) more {
	available  += more;
}

- (NSNumber *) limit {
	return limit;
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACServicePage");
	#endif
	GDRelease(pagesize);
	GDRelease(offset);
	GDRelease(totalRows);
	available = 0;
	[super dealloc];
}

@end
