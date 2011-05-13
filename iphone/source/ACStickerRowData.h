
#import <Foundation/Foundation.h>
#import "macros.h"

typedef enum {
	kACStickerCellTypeNormal = 1,
	kACStickerCellTypeNone = 2
} kACStickerCellType;

@interface ACStickerRowData : NSObject {
	kACStickerCellType celltype;
	UIImage * stickerThumbImage;
	UIImage * stickerLargeImage;
	NSString * stickerName;
}

@property (nonatomic,assign) kACStickerCellType celltype;
@property (nonatomic,retain) UIImage * stickerThumbImage;
@property (nonatomic,retain) UIImage * stickerLargeImage;
@property (nonatomic,copy) NSString * stickerName;

+ (ACStickerRowData *) rowDataWithStickerName:(NSString *) name stickerThumb:(UIImage *) image andLargeImage:(UIImage *) image;
+ (ACStickerRowData *) dataForCellType:(kACStickerCellType) celltype;

@end
