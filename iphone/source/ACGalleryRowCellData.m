
#import "ACGalleryRowCellData.h"

static Boolean renderExploreView;

@implementation ACGalleryRowCellData
@synthesize title;
@synthesize rating;
@synthesize tagCount;
@synthesize largeURL;
@synthesize thumbURL;
@synthesize largeFilename;
@synthesize thumbFilename;
@synthesize tagId;
@synthesize thoroughfare;
@synthesize subThoroughfare;
@synthesize locality;
@synthesize subLocality;
@synthesize administrativeArea;
@synthesize subAdministrativeArea;
@synthesize postalcode;
@synthesize country;
@synthesize celltype;
@synthesize uid;

+ (Boolean) renderExploreView {
	return renderExploreView;
}

+ (void) setRenderExploreView:(Boolean) render {
	renderExploreView = render;
}

+ (ACGalleryRowCellData *) dataForCellType:(kCellType) ct {
	ACGalleryRowCellData * d = [[ACGalleryRowCellData alloc] init];
	[d setCelltype:ct];
	return [d autorelease];
}

+ (ACGalleryRowCellData *) rowWithTagId:(NSNumber *) _tagId large:(NSString *) _large thumb:(NSString *) _thumb title:(NSString *) _title rating:(int) _rating andTagCount:(NSNumber *) _tagCount {
	ACGalleryRowCellData * d = [[ACGalleryRowCellData alloc] init];
	[d setTagId:_tagId];
	[d setLargeURL:_large andThumbURL:_thumb];
	[d setTitle:_title];
	[d setRating:_rating];
	[d setTagCount:_tagCount];
	return [d autorelease];
}

- (void) encodeWithCoder:(NSCoder *) aCoder {
	NSKeyedArchiver * archiver = (NSKeyedArchiver *)aCoder;
	[archiver encodeInt:rating forKey:@"ACGalleryRowCellData.rating"];
	[archiver encodeInt:celltype forKey:@"ACGalleryRowCellData.celltype"];
	[archiver encodeObject:title forKey:@"ACGalleryRowCellData.title"];
	[archiver encodeObject:largeFilename forKey:@"ACGalleryRowCellData.largeFilename"];
	[archiver encodeObject:thumbFilename forKey:@"ACGalleryRowCellData.thumbFilename"];
	[archiver encodeObject:largeURL forKey:@"ACGalleryRowCellData.largeURL"];
	[archiver encodeObject:thumbURL forKey:@"ACGalleryRowCellData.thumbURL"];
	[archiver encodeObject:thoroughfare forKey:@"ACGalleryRowCellData.thoroughfare"];
	[archiver encodeObject:subThoroughfare forKey:@"ACGalleryRowCellData.subThoroughfare"];
	[archiver encodeObject:locality forKey:@"ACGalleryRowCellData.locality"];
	[archiver encodeObject:subLocality forKey:@"ACGalleryRowCellData.subLocality"];
	[archiver encodeObject:administrativeArea forKey:@"ACGalleryRowCellData.administrativeArea"];
	[archiver encodeObject:subAdministrativeArea forKey:@"ACGalleryRowCellData.subAdministrativeArea"];
	[archiver encodeObject:postalcode forKey:@"ACGalleryRowCellData.postalcode"];
	[archiver encodeObject:country forKey:@"ACGalleryRowCellData.country"];
	[archiver encodeObject:tagId forKey:@"ACGalleryRowCellData.tagId"];
	[archiver encodeObject:tagCount forKey:@"ACGalleryRowCellData.tagCount"];
}

- (id) initWithCoder:(NSCoder *) aDecoder {
	if(!(self = [super init])) return nil;
	NSKeyedUnarchiver * unarchiver = (NSKeyedUnarchiver *)aDecoder;
	rating = [unarchiver decodeIntForKey:@"ACGalleryRowCellData.rating"];
	celltype = [unarchiver decodeIntForKey:@"ACGalleryRowCellData.celltype"];
	title = [[unarchiver decodeObjectForKey:@"ACGalleryRowCellData.title"] retain];
	GDRelease(largeFilename);
	GDRelease(thumbFilename);
	GDRelease(thumbURL);
	GDRelease(largeURL);
	largeFilename = [[unarchiver decodeObjectForKey:@"ACGalleryRowCellData.largeFilename"] retain];
	thumbFilename = [[unarchiver decodeObjectForKey:@"ACGalleryRowCellData.thumbFilename"] retain];
	largeURL = [[unarchiver decodeObjectForKey:@"ACGalleryRowCellData.largeURL"] retain];
	thumbURL = [[unarchiver decodeObjectForKey:@"ACGalleryRowCellData.thumbURL"] retain];
	thoroughfare = [[unarchiver decodeObjectForKey:@"ACGalleryRowCellData.thoroughfare"] retain];
	subThoroughfare = [[unarchiver decodeObjectForKey:@"ACGalleryRowCellData.subThoroughfare"] retain];
	locality = [[unarchiver decodeObjectForKey:@"ACGalleryRowCellData.locality"] retain];
	subLocality = [[unarchiver decodeObjectForKey:@"ACGalleryRowCellData.subLocality"] retain];
	administrativeArea = [[unarchiver decodeObjectForKey:@"ACGalleryRowCellData.administrativeArea"] retain];
	subAdministrativeArea = [[unarchiver decodeObjectForKey:@"ACGalleryRowCellData.subAdministrativeArea"] retain];
	postalcode = [[unarchiver decodeObjectForKey:@"ACGalleryRowCellData.postalcode"] retain];
	country = [[unarchiver decodeObjectForKey:@"ACGalleryRowCellData.country"] retain];
	tagId = [[unarchiver decodeObjectForKey:@"ACGalleryRowCellData.tagId"] retain];
	tagCount = [[unarchiver	decodeObjectForKey:@"ACGalleryRowCellData.tagCount"] retain];
	return self;
}

- (void) setThoroughfare:(NSString *) _th subThoroughfare:(NSString *) _sth locality:(NSString *) _lcl subLocality:(NSString *) _slcl {
	[self setThoroughfare:_th];
	[self setSubThoroughfare:_sth];
	[self setLocality:_lcl];
	[self setSubLocality:_slcl];
}

- (void) setAdministrativeArea:(NSString *) _ada subAdministrativeArea:(NSString *) _sada postalcode:(NSString *) _pc country:(NSString *) _cntry {
	[self setAdministrativeArea:_ada];
	[self setSubAdministrativeArea:_sada];
	[self setPostalcode:_pc];
	[self setCountry:_cntry];
}

- (void) setLargeURL:(NSString *) _largeURL andThumbURL:(NSString *) _thumbURL {
	[self setLargeURL:_largeURL];
	[self setThumbURL:_thumbURL];
}

- (void) setLargeFilename:(NSString *) large andThumbFilename:(NSString *) thumb {
	[self setLargeFilename:large];
	[self setThumbFilename:thumb];
}

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACGalleryRowCellData");
	#endif
	GDRelease(thoroughfare);
	GDRelease(subThoroughfare);
	GDRelease(locality);
	GDRelease(subLocality);
	GDRelease(administrativeArea);
	GDRelease(subAdministrativeArea);
	GDRelease(postalcode);
	GDRelease(country);
	GDRelease(title);
	GDRelease(largeURL);
	GDRelease(thumbURL);
	GDRelease(largeFilename);
	GDRelease(thumbFilename);
	GDRelease(tagCount);
	GDRelease(tagId);
	GDRelease(uid);
	[super dealloc];
}

@end
