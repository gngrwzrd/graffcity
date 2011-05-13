
#import <Foundation/Foundation.h>
#import "macros.h"

typedef enum {
	kCellTypeGallery = 1,
	kCellTypeExplore = 2,
	kCellTypeNoResults = 3,
	kCellTypeMore = 4
} kCellType;

@interface ACGalleryRowCellData : NSObject <NSCoding> {
	int rating;
	int celltype;
	NSString * title;
	NSString * largeFilename;
	NSString * thumbFilename;
	NSString * largeURL;
	NSString * thumbURL;
	NSString * thoroughfare;
	NSString * subThoroughfare;
	NSString * locality;
	NSString * subLocality;
	NSString * administrativeArea;
	NSString * subAdministrativeArea;
	NSString * postalcode;
	NSString * country;
	NSNumber * tagId;
	NSNumber * tagCount;
	NSNumber * uid;
}

@property (nonatomic,assign) int rating;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * largeURL;
@property (nonatomic,copy) NSString * thumbURL;
@property (nonatomic,copy) NSString * largeFilename;
@property (nonatomic,copy) NSString * thumbFilename;
@property (nonatomic,copy) NSString * thoroughfare;
@property (nonatomic,copy) NSString * subThoroughfare;
@property (nonatomic,copy) NSString * locality;
@property (nonatomic,copy) NSString * subLocality;
@property (nonatomic,copy) NSString * administrativeArea;
@property (nonatomic,copy) NSString * subAdministrativeArea;
@property (nonatomic,copy) NSString * postalcode;
@property (nonatomic,copy) NSString * country;
@property (nonatomic,retain) NSNumber * tagId;
@property (nonatomic,retain) NSNumber * tagCount;
@property (nonatomic,retain) NSNumber * uid;
@property (nonatomic,assign) int celltype;

+ (Boolean) renderExploreView;
+ (void) setRenderExploreView:(Boolean) render;
+ (ACGalleryRowCellData *) dataForCellType:(kCellType) ct;
+ (ACGalleryRowCellData *) rowWithTagId:(NSNumber *) _tagId large:(NSString *) _large thumb:(NSString *) _thumb title:(NSString *) _title rating:(int) _rating andTagCount:(NSNumber *) _tagCount;
- (void) setLargeURL:(NSString *) _largeURL andThumbURL:(NSString *) _thumbURL;
- (void) setThoroughfare:(NSString *) _th subThoroughfare:(NSString *) _sth locality:(NSString *) _lcl subLocality:(NSString *) _slcl;
- (void) setAdministrativeArea:(NSString *) _ada subAdministrativeArea:(NSString *) _sada postalcode:(NSString *) _pc country:(NSString *) _cntry;
- (void) setLargeFilename:(NSString *) large andThumbFilename:(NSString *) thumb;

@end
