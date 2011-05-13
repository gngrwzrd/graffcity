
#import "ACServicesHelper.h"

@implementation ACServicesHelper

+ (NSString *) getS3FilepathFromFileName:(NSString *) filename {
	NSNull * nl = [NSNull null];
	if((id)filename == nl) return nil;
	//unichar first = [filename characterAtIndex:0];
	//unichar second = [filename characterAtIndex:1];
	//unichar third = [filename characterAtIndex:2];
	//NSString * three = [NSString stringWithFormat:@"%c%c%c",first,second,third];
	NSString * path = [NSString stringWithFormat:@"%@%@",ACTagStorage,filename];
	return path;
}

@end
