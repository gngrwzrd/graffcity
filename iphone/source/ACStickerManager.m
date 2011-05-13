
#import "ACStickerManager.h"

static ACStickerManager * inst = nil;

@implementation ACStickerManager

+ (ACStickerManager *) sharedInstance {
	@synchronized(self) {
		if(!inst) {
			inst = [[self alloc] init];
		}
	}
	return inst;
}

+ (NSString *) stickerName {
	NSDate * date = [NSDate date];
	NSTimeInterval time = [date timeIntervalSince1970];
	NSCharacterSet * testSet = [NSCharacterSet characterSetWithCharactersInString:@" 1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
	NSString * frmt = [NSString stringWithFormat:@"%f",time];
	NSString * formattedName = [[frmt componentsSeparatedByCharactersInSet:[testSet invertedSet]] componentsJoinedByString:@""];
	NSString * stickerName = [NSString stringWithFormat:@"sticker_%@.png",formattedName];
	return stickerName;
}

- (id) init {
	if(!(self = [super init])) return nil;
	thumbWidth = 100;
	thumbHeight = 100;
	dirPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/stickers/raw"] retain];
	thumbPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/stickers/thumbs"] retain];
	return self;
}

- (Boolean) doesStickerExists:(NSString *) stickerName {
	NSFileManager * fileManager = [NSFileManager defaultManager];
	NSString * fileName = [self formatFileName:stickerName];
	NSString * path = [NSString stringWithFormat:@"%@/%@",dirPath,fileName];
	return [fileManager fileExistsAtPath:path];
}

- (NSString *) formatFileName:(NSString *) name {
	NSCharacterSet * testSet = [NSCharacterSet characterSetWithCharactersInString:@" 1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
	NSString * formattedName = [[name componentsSeparatedByCharactersInSet:[testSet invertedSet]] componentsJoinedByString:@""];
	formattedName = [formattedName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	return [NSString stringWithFormat:@"%@.png",formattedName];
}

- (Boolean) saveSticker:(UIImage *) image forName:(NSString *) name {
	NSFileManager * fileManager = [NSFileManager defaultManager];
	NSString * fileName = [self formatFileName:name];
	if([self doesStickerExists:name]) return false;
	NSData * largeData = UIImagePNGRepresentation(image);
	NSData * thumbData = UIImagePNGRepresentation([self createThumbnail:image]);
	NSString * large = [NSString stringWithFormat:@"%@/%@",dirPath,fileName];
	NSString * thumb = [NSString stringWithFormat:@"%@/%@",thumbPath,fileName];
	[fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:true attributes:nil error:nil];
	[fileManager createDirectoryAtPath:thumbPath withIntermediateDirectories:true attributes:nil error:nil];
	[largeData writeToFile:large atomically:true];
	[thumbData writeToFile:thumb atomically:true];
	return true;
}

- (Boolean) removeStickerByName:(NSString *) fileName {
	NSFileManager * fileManager = [NSFileManager defaultManager];
	NSString * thumb = [NSString stringWithFormat:@"%@/%@",thumbPath,fileName];
	NSString * large = [NSString stringWithFormat:@"%@/%@",dirPath,fileName];
	[fileManager removeItemAtPath:thumb error:nil];
	[fileManager removeItemAtPath:large error:nil];
	return true;
}

- (UIImage *) createThumbnail:(UIImage *) image {
	CGImageRef imageRef = [image CGImage];
	CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
	CGContextRef bitmap = CGBitmapContextCreate(NULL,thumbWidth,thumbHeight,CGImageGetBitsPerComponent(imageRef),4*thumbWidth,CGImageGetColorSpace(imageRef),alphaInfo);
	CGContextDrawImage(bitmap,CGRectMake(0,0,thumbWidth,thumbHeight),imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage * resized = [UIImage imageWithCGImage:ref];
	CGContextRelease(bitmap);
	CGImageRelease(ref);
	return resized;
}

- (UIImage *) createThumbnail:(UIImage *) image withWidth:(NSInteger) tw andHeight:(NSInteger) th {
	CGImageRef imageRef = [image CGImage];
	CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
	CGContextRef bitmap = CGBitmapContextCreate(NULL,tw,th,CGImageGetBitsPerComponent(imageRef),4*tw,CGImageGetColorSpace(imageRef),alphaInfo);
	CGContextDrawImage(bitmap, CGRectMake(0,0,tw,th),imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage * resized = [UIImage imageWithCGImage:ref];
	CGContextRelease(bitmap);
	CGImageRelease(ref);
	return resized;	
}

- (NSArray *) listStickers {
	NSFileManager * fileManager = [NSFileManager defaultManager];
	return [fileManager contentsOfDirectoryAtPath:dirPath error:NULL];
}

- (NSArray *) listThumbs {
	NSFileManager * fileManager = [NSFileManager defaultManager];
	return [fileManager contentsOfDirectoryAtPath:thumbPath error:NULL];
}

- (NSArray *) listNames {
	NSFileManager * fileManager = [NSFileManager defaultManager];
	return [fileManager contentsOfDirectoryAtPath:dirPath error:nil];
}

- (UIImage *) getLargeImageNamed:(NSString *) imageName {
	UIImage * image = [[UIImage	alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",dirPath,imageName]];
	return [image autorelease];
}

- (UIImage *) getThumbImageNamed:(NSString *) imageName {
	UIImage * image = [[UIImage	alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",thumbPath,imageName]];
	return [image autorelease];
}

+ (id) allocWithZone:(NSZone *) zone {
	@synchronized(self) {
		if(inst == nil) {
			inst = [super allocWithZone:zone];
			return inst;
		}
	}
	return nil;
}

- (id) copyWithZone:(NSZone *) zone {
	return self;
}

- (id) retain {
	return self;
}

- (NSUInteger) retainCount {
	return UINT_MAX;
}

- (id) autorelease {
	return self;
}

- (void) release {}

@end
