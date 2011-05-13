
#import <Foundation/Foundation.h>

@interface ACStickerManager : NSObject {
	int thumbWidth;
	int thumbHeight;
	NSString * dirPath;
	NSString * thumbPath;
}

+ (ACStickerManager *) sharedInstance;
+ (NSString *) stickerName;
- (Boolean) doesStickerExists:(NSString *) stickerName;
- (Boolean) saveSticker:(UIImage *) image forName:(NSString *) name;
- (Boolean) removeStickerByName:(NSString *) name;
- (NSString *) formatFileName:(NSString *) name;
- (UIImage *) createThumbnail:(UIImage *) image;
- (UIImage *) createThumbnail:(UIImage *) image withWidth:(NSInteger) tw andHeight:(NSInteger) th;
- (NSArray *) listStickers;
- (NSArray *) listThumbs;
- (NSArray *) listNames;
- (UIImage *) getLargeImageNamed:(NSString *) imageName;
- (UIImage *) getThumbImageNamed:(NSString *) imageName;

@end
