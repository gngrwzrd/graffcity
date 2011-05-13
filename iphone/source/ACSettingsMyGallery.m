
#import "ACSettingsMyGallery.h"
#import "ACAppController.h"

extern ACSettings * settings_instance;
static NSString * cachepath;

@implementation ACSettingsMyGallery
@synthesize table;
@synthesize activity;
@synthesize container;
@synthesize galleryItems;

+ (void) expireCachedGalleryData {
	[[NSFileManager defaultManager] removeItemAtPath:cachepath error:nil];
}

- (IBAction) back {
	[[app views] popViewControllerAnimated:false];
}

- (IBAction) refresh {
	[page reset];
	[ACSettingsMyGallery expireCachedGalleryData];
	[ACListTagsService expireCache];
	recache = true;
	[self performGetTagsForProfile];
}

- (void) deleteCell:(ACGalleryRowCell *) cell {
	ACGalleryRowCellData * d = [data itemInSection:0 atIndex:[cell index]];
	deletingCellIndex = [cell index];
	deletingData = [d retain];
	[self performDeleteTagWithTagId:[d tagId]];
}

- (void) galleryRowDidPressArrow:(ACGalleryRowCell *) cell {
	[settings_instance showingTagViewer];
	[viewer setData:[data dataInSection:0]];
	[viewer setSelectedItem:[data itemInSection:0 atIndex:[cell index]]];
	[[app views] pushViewController:viewer animated:false];
	[viewer checkFor0Selection];
}

- (void) galleryShouldLoadMore {
	recache = true;
	[data removeLastItemInSection:0];
	[page stepOffset];
	[self performGetTagsForProfile];
}

- (void) performGetTagsForProfile {
	cacheExists = [[NSFileManager defaultManager] fileExistsAtPath:cachepath];
	if(!recache && cacheExists) {
		[self reloadTableData];
		GDRelease(listTagsService);
		return;
	}
	[app showServiceIndicator];
	GDRelease(listTagsService);
	listTagsService = [[ACListTagsService serviceWithUsername:[user username] andOffset:[page offset] andLimit:[page limit]] retain];
	[listTagsService setJsonCacheKey:[ACListTagsService jsonCacheKey]];
	[listTagsService setUseCache:false];
	[listTagsService setFinished:GDCreateCallback(self,listTagsFinished) andFailed:GDCreateCallback(self,listTagsFailed)];
	[listTagsService sendAsync];
}

- (void) listTagsFinished {
	[app hideServiceIndicator];
	recache = true;
	[self reloadTableData];
	recache = false;
	GDRelease(listTagsService);
}

- (void) listTagsFailed {
	[app hideServiceIndicator];
	[listTagsService showFaultMessage];
	[settings_instance showError];
	GDRelease(listTagsService);
}

- (void) performDeleteTagWithTagId:(NSNumber *) tagId {
	[app showServiceIndicator];
	GDRelease(deleteTagService);
	deleteTagService = [[ACDeleteTagService serviceWithTagId:tagId username:[user username] andPassword:[user password]] retain];
	[deleteTagService setUseCache:false];
	[deleteTagService setFinished:GDCreateCallback(self,deleteTagFinished) andFailed:GDCreateCallback(self,deleteTagFailed)];
	[deleteTagService sendAsync];
}

- (void) deleteTagFinished {
	[ACProfileInfoService expireCache];
	[app hideServiceIndicator];
	[data removeItemInSection:0 atIndex:deletingCellIndex];
	recache = true;
	[self reloadTableData];
	recache = false;
	GDRelease(deleteTagService);
	GDRelease(deletingData);
}

- (void) deleteTagFailed {
	[app hideServiceIndicator];
	[deleteTagService showFaultMessage];
	GDRelease(deleteTagService);
}

- (void) reloadTableData {
	ACGalleryRowCellData * d;
	NSArray * sdata;
	NSNumber * totalRows;
	NSNull * nl = [NSNull null];
	if(!recache && cacheExists) {
		[page reset];
		NSData * dt = [[NSData alloc] initWithContentsOfFile:cachepath];
		NSKeyedUnarchiver * ua = [[NSKeyedUnarchiver alloc] initForReadingWithData:dt];
		NSArray * ard = [ua decodeObjectForKey:@"ACSettingsMyGallery.CacheData"];
		totalRows = [ua decodeObjectForKey:@"ACSettingsMyGallery.TotalRows"];
		[ua finishDecoding];
		[data removeAllItemsInSection:0];
		[data setData:[NSMutableArray arrayWithArray:ard]];
		if(deletingData) {
			recache = true;
			[data removeItemInSection:0 atIndex:deletingCellIndex];
			if([data countOfItemsInSection:0] < 1) {
				[data addItem:[ACGalleryRowCellData dataForCellType:kCellTypeNoResults] toSection:0];
				[ACProfileInfoService expireCache];
			}
		}
		[page setAvailable:[ard count]];
		[dt release];
		[ua release];
	} else {
		sdata = [listTagsService data];
		totalRows = [[listTagsService response] objectForKey:@"totalRows"];
	}
	[page setTotalRows:totalRows];
	if(recache) {
		if([totalRows intValue] > 0) {
			if([[page offset] intValue] == 0) [data removeAllItemsInSection:0];
			NSInteger count = [sdata count];
			[page addMoreAvailable:count];
			NSInteger i = 0;
			NSInteger rated;
			NSString * username;
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
			NSNumber * rating;
			NSNumber * rateCount;
			NSNumber * tagCount;
			NSNumber * tagId;
			NSDictionary * item;
			int r;
			int rc;
			float b;
			for(i;i<count;i++) {
				item = [sdata objectAtIndex:i];
				tagId = [item objectForKey:@"tagId"];
				username = [item objectForKey:@"username"];
				largeURL = [item objectForKey:@"large"];
				thumbURL = [item objectForKey:@"thumb"];
				largeFilename = [item objectForKey:@"large"];
				thumbFilename = [item objectForKey:@"thumb"];
				rating = [item objectForKey:@"rating"];
				rateCount = [item objectForKey:@"rateCount"];
				tagCount = [item objectForKey:@"totalTags"];
				thoroughfare = [item objectForKey:@"thoroughfare"];
				subThoroughfare = [item objectForKey:@"subThoroughfare"];
				locality = [item objectForKey:@"locality"];
				subLocality = [item objectForKey:@"subLocality"];
				administrativeArea = [item objectForKey:@"administrativeArea"];
				subAdministrativeArea = [item objectForKey:@"subAdministrativeArea"];
				postalcode = [item objectForKey:@"postalcode"];
				country = [item objectForKey:@"country"];
				if(largeURL && (id)largeURL != nl) largeURL = [ACServicesHelper getS3FilepathFromFileName:largeURL];
				if(thumbURL && (id)thumbURL != nl) thumbURL = [ACServicesHelper getS3FilepathFromFileName:thumbURL];
				r = [rating intValue];
				rc = [rateCount intValue];
				if(r < 1) r = 1;
				if(rc < 1) rc = 1;
				b = (float)r / (float)rc;
				rated = ceil(b);
				d = [ACGalleryRowCellData rowWithTagId:tagId large:largeURL thumb:thumbURL title:username rating:rated andTagCount:tagCount];
				[d setCelltype:kCellTypeGallery];
				[d setThoroughfare:thoroughfare subThoroughfare:subThoroughfare locality:locality subLocality:subLocality];
				[d setAdministrativeArea:administrativeArea subAdministrativeArea:subAdministrativeArea postalcode:postalcode country:country];
				[d setLargeFilename:largeFilename andThumbFilename:thumbFilename];
				[data addItem:d toSection:0];
			}
			if([sdata count] >= 25) [data addItem:[ACGalleryRowCellData dataForCellType:kCellTypeMore] toSection:0];
		} else if(recache && [[page offset] intValue] == 0 && !deletingData) {
			[data removeAllItemsInSection:0];
			[data addItem:[ACGalleryRowCellData dataForCellType:kCellTypeNoResults] toSection:0];
		} else if([data countOfItemsInSection:0] > 0) {
		} else {
			[data removeAllItemsInSection:0];
			[data addItem:[ACGalleryRowCellData dataForCellType:kCellTypeNoResults] toSection:0];
		}
	}
	if(recache) {
		NSMutableArray * ard = [data data];
		NSMutableData * dt = [NSMutableData data];
		NSKeyedArchiver * ka = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dt];
		[ka encodeObject:ard forKey:@"ACSettingsMyGallery.CacheData"];
		[ka encodeObject:totalRows forKey:@"ACSettingsMyGallery.TotalRows"];
		[ka finishEncoding];
		[dt writeToFile:cachepath atomically:true];
		[ka release];
		recache = false;
	}
	[table setDataSource:data];
	[table reloadData];
	deletingData = nil;
	deletingCellIndex = 0;
}

- (void) viewDidGoIn {
	user = [ACUserInfo sharedInstance];
	[page reset];
	[self performGetTagsForProfile];
}

- (void) viewDidGoOut {
	
}

- (void) unloadView {
	[table setDataSource:nil];
	GDRelease(table);
	GDRelease(viewer);
	GDRelease(listTagsService);
	[self setView:nil];
}

- (void) viewDidLoad {
	if(!cachepath) cachepath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/cache/profile_gallery"] retain];
	[[NSFileManager defaultManager] createDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/cache"] withIntermediateDirectories:true attributes:nil error:nil];
	app = [ACAppController sharedInstance];
	page = [[ACServicePage alloc] init];
	data = [[ACTableDataSourceController alloc] init];
	viewer = [[ACTagViewer alloc] initWithNibName:@"TagViewer" bundle:nil];
	onCellPressed = [GDCreateCallback(self,galleryRowDidPressArrow:) retain];
	onMorePressed = [GDCreateCallback(self,galleryShouldLoadMore) retain];
	onDeleteSwiped = [GDCreateCallback(self,deleteCell:) retain];
	[viewer setShowUsername:false];
	[data addSection];
	[data setOnCellPressed:onCellPressed];
	[data setOnMorePressed:onMorePressed];
	[data setOnDeleteSwiped:onDeleteSwiped];
	[container addSubview:galleryItems];
}

- (void) viewDidUnload {
	[super viewDidUnload];
}

- (void) didReceiveMemoryWarning {
	if(![[self view] superview]) [self unloadView];
	[super didReceiveMemoryWarning];
}

- (void) dealloc {
	[self unloadView];
	GDRelease(data);
	GDRelease(container);
	GDRelease(galleryItems);
	GDRelease(activity);
	GDRelease(page);
	GDRelease(onCellPressed);
	GDRelease(onMorePressed);
	GDRelease(onDeleteSwiped);
	app = nil;
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACSettingsMyGallery");
	#endif
	[super dealloc];
}

@end
