
#import "ACExplore.h"
#import "ACAppController.h"

@implementation ACExplore
@synthesize table;
@synthesize searchField;
@synthesize nearbyButton;
@synthesize latestButton;
@synthesize ratingButton;
@synthesize arButton;

- (IBAction) back {
	[[app views] popViewControllerAnimated:false];
}

- (IBAction) refresh {
	[[self view] findAndResignFirstResonder];
	switch (refresh) {
		case kACExploreRefreshTypeNone:
			return;
			break;
		case kACExploreRefreshTypeNearby:
			[self performNearby];
			break;
		case kACExploreRefreshTypeLatest:
			[self performLatest];
			break;
		case kACExploreRefreshTypeRating:
			[self performRating];
			break;
		case kACExploreRefreshTypeSearch:
			if(!loadingAnotherPage) GDRelease(lastSearch);
			[self performSearch];
		default:
			break;
	}
}

- (IBAction) nearby {
	if(selectedButton == nearbyButton) return;
	switchedService = true;
	[self selectButton:nearbyButton];
	[self performNearby];
	switchedService = false;
}

- (IBAction) latest {
	if(selectedButton == latestButton) return;
	switchedService = true;
	[self selectButton:latestButton];
	[self performLatest];
	switchedService = false;
}

- (IBAction) rating {
	if(selectedButton == ratingButton) return;
	switchedService = true;
	[self selectButton:ratingButton];
	[self performRating];
	switchedService = false;
}

- (IBAction) search {
	[[self view] findAndResignFirstResonder];
	switchedService = true;
	[self performSearch];
	switchedService = false;
}

- (IBAction) ar {
	[viewer setData:lastNearbyData];
	[[app views] pushViewController:ar animated:false];
}

- (void) deleteCell:(ACGalleryRowCell *) cell {
	ACGalleryRowCellData * d = [data itemInSection:0 atIndex:[cell index]];
	deletingCellIndex = [cell index];
	deletingData = [d retain];
	[self performDeleteTagWithTagId:[d tagId]];
}

- (void) arViewControllerDidPressBack:(ARViewController *) arViewController {
	[[app views] popViewControllerAnimated:false];
}

- (void) arViewControllerDidPressRefresh:(ARViewController *) arViewController {
	
}

- (void) arCellTouchedUpInside:(ARCell *) arCell {
	ACGalleryRowCellData * d = [arCell data];
	[viewer setData:lastNearbyData];
	[viewer setSelectedItem:d];
	[[app views] pushViewController:viewer animated:false];
	[viewer checkFor0Selection];
}

- (void) onCellPressed:(ACGalleryRowCell *) cell {
	[viewer setData:[data dataInSection:0]];
	[viewer setSelectedItem:[data itemInSection:0 atIndex:[cell index]]];
	[[app views] pushViewController:viewer animated:false];
	[viewer checkFor0Selection];
}

- (void) onLoadMorePressed {
	loadingAnotherPage = true;
	[data removeLastItemInSection:0];
	[page stepOffset];
	[self refresh];
	loadingAnotherPage = false;
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
	[app hideServiceIndicator];
	[data removeItemInSection:0 atIndex:deletingCellIndex];
	[self refresh];
	GDRelease(deleteTagService);
	GDRelease(deletingData);
}

- (void) deleteTagFailed {
	[app hideServiceIndicator];
	[deleteTagService showFaultMessage];
	GDRelease(deleteTagService);
}

- (void) performNearby {
	if([[page offset] intValue] == 0) {
		[ar removeAllViews];
		[page reset];
	}
	[app showServiceIndicator];
	if(!loadingAnotherPage) [page reset];
	if(switchedService && !loadingAnotherPage) {
		if([table dataSource]) [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:false];
		[page reset];
	}
	[self serviceStart];
	hasLoadedDefaultNearby = true;
	CLLocationDegrees lat = [app currentLatitude];
	CLLocationDegrees lon = [app currentLongitude];
	GDRelease(nearbyService);
	nearbyService = [[ACNearbyService serviceWithLatitude:lat longitude:lon offset:[page offset] andLimit:[page limit]] retain];
	[nearbyService setUseCache:false];
	[nearbyService setFinished:GDCreateCallback(self,onNearbyFinished) andFailed:GDCreateCallback(self,onNearbyFailed)];
	[nearbyService sendAsync];
	
	//fire ar nearby
	GDRelease(arNearbyService);
	arNearbyService = [[ACARNearbyService serviceWithLatitude:lat longitude:lon offset:[NSNumber numberWithInt:0] andLimit:[NSNumber numberWithInt:10]] retain];
	[arNearbyService setUseCache:false];
	[arNearbyService setFinished:GDCreateCallback(self,onARNearbyFinished) andFailed:GDCreateCallback(self,onARNearbyFailed)];
	[arNearbyService sendAsync];
}

- (void) onARNearbyFinished {
	[lastNearbyData removeAllObjects];
	[ar removeAllViews];
	NSMutableArray * dt = [arNearbyService data];
	if([dt count] < 1) {
		[arButton setEnabled:false];
		return;
	}
	[arButton setEnabled:true];
	if(!canUseAR) [arButton setEnabled:false];
	ARCell * cell;
	ACGalleryRowCellData * d;
	NSInteger i = 0;
	NSInteger count = [dt count];
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
	NSNumber * lat;
	NSNumber * lon;
	NSNumber * uid;
	NSDictionary * item;
	CLLocation * location;
	CLLocationDegrees latit;
	CLLocationDegrees longi;
	int r;
	int rc;
	float b;
	for(i;i<count;i++) {
		item = [dt objectAtIndex:i];
		tagId = [item objectForKey:@"tagId"];
		uid = [item objectForKey:@"userId"];
		lat = [item objectForKey:@"latitude"];
		lon = [item objectForKey:@"longitude"];
		latit = (CLLocationDegrees)[lat doubleValue];
		longi = (CLLocationDegrees)[lon doubleValue];
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
		if(largeURL) largeURL = [ACServicesHelper getS3FilepathFromFileName:largeURL];
		if(thumbURL) thumbURL = [ACServicesHelper getS3FilepathFromFileName:thumbURL];
		r = [rating intValue];
		rc = [rateCount intValue];
		if(r < 1) r = 1;
		if(rc < 1) rc = 1;
		b = (float)r / (float)rc;
		rated = ceil(b);
		d = [ACGalleryRowCellData rowWithTagId:tagId large:largeURL thumb:thumbURL title:username rating:rated andTagCount:tagCount];
		[d setUid:uid];
		[d setCelltype:kCellTypeExplore];
		[d setThoroughfare:thoroughfare subThoroughfare:subThoroughfare locality:locality subLocality:subLocality];
		[d setAdministrativeArea:administrativeArea subAdministrativeArea:subAdministrativeArea postalcode:postalcode country:country];
		[d setLargeFilename:largeFilename andThumbFilename:thumbFilename];
		[lastNearbyData addObject:d];
		location = [[CLLocation alloc] initWithLatitude:latit longitude:longi];
		cell = [[ARCell alloc] initWithNibName:@"ARCell" bundle:nil];
		[cell setData:d];
		[cell setDelegate:self];
		[ar addARView:cell withLocation:location];
		[cell release];
		[location release];
	}
	GDRelease(arNearbyService);
}

- (void) onARNearbyFailed {
	GDRelease(arNearbyService);
	[arButton setEnabled:false];
}

- (void) onNearbyFinished {
	[app hideServiceIndicator];
	refresh = kACExploreRefreshTypeNearby;
	serviceData = [[nearbyService data] retain];
	serviceTotalRows = [[nearbyService totalRows] retain];
	if([serviceTotalRows intValue] < 1 || !canUseAR) [arButton setEnabled:false];
	else [arButton setEnabled:true];
	addARCells = true;
	saveNearbyData = true;
	[self serviceComplete];
	[self reloadTableData];
	saveNearbyData = false;
	addARCells = false;
	GDRelease(nearbyService);
}

- (void) onNearbyFailed {
	[app hideServiceIndicator];
	[arButton setEnabled:false];
	refresh = kACExploreRefreshTypeNearby;
	[self serviceComplete];
	[data removeAllItemsInSection:0];
	[data addItem:[ACGalleryRowCellData dataForCellType:kCellTypeNoResults] toSection:0];
	if(![table dataSource]) [table setDataSource:data];
	[table reloadData];
	GDRelease(nearbyService);
}

- (void) performLatest {
	[app showServiceIndicator];
	if(!loadingAnotherPage) [page reset];
	if(switchedService && !loadingAnotherPage) {
		if([table dataSource]) [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:false];
		[page reset];
	}
	[self serviceStart];
	GDRelease(latestService);
	latestService = [[ACLatestService serviceWithOffset:[page offset] andLimit:[page limit]] retain];
	[latestService setFinished:GDCreateCallback(self,onLatestFinished) andFailed:GDCreateCallback(self,onLatestFailed)];
	[latestService sendAsync];
}

- (void) onLatestFinished {
	[app hideServiceIndicator];
	refresh = kACExploreRefreshTypeLatest;
	serviceData = [[latestService data] retain];
	serviceTotalRows = [[latestService totalRows] retain];
	[self serviceComplete];
	[self reloadTableData];
	GDRelease(lastSearch);
	GDRelease(latestService);
}

- (void) onLatestFailed {
	[app hideServiceIndicator];
	[self serviceComplete];
	refresh = kACExploreRefreshTypeLatest;
	[data removeAllItemsInSection:0];
	[data addItem:[ACGalleryRowCellData dataForCellType:kCellTypeNoResults] toSection:0];
	if(![table dataSource]) [table setDataSource:data];
	[table reloadData];
	GDRelease(lastSearch);
	GDRelease(latestService);
}

- (void) performRating {
	[app showServiceIndicator];
	if(!loadingAnotherPage) [page reset];
	if(switchedService && !loadingAnotherPage) {
		if([table dataSource]) [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:false];
		[page reset];
	}
	[self serviceStart];
	GDRelease(ratingService);
	ratingService = [[ACRatingService serviceWithOffset:[page offset] andLimit:[page limit]] retain];
	[ratingService setFinished:GDCreateCallback(self,onRatingFinished) andFailed:GDCreateCallback(self,onRatingFailed)];
	[ratingService sendAsync];
}

- (void) onRatingFinished {
	[app hideServiceIndicator];
	refresh = kACExploreRefreshTypeRating;
	serviceData = [[ratingService data] retain];
	serviceTotalRows = [[ratingService totalRows] retain];
	[self serviceComplete];
	[self reloadTableData];
	GDRelease(lastSearch);
	GDRelease(ratingService);
}

- (void) onRatingFailed {
	[app hideServiceIndicator];
	[self serviceComplete];
	refresh = kACExploreRefreshTypeRating;
	[data removeAllItemsInSection:0];
	[data addItem:[ACGalleryRowCellData dataForCellType:kCellTypeNoResults] toSection:0];
	if(![table dataSource]) [table setDataSource:data];
	[table reloadData];
	GDRelease(lastSearch);
	GDRelease(ratingService);
}

- (void) performSearch {
	NSString * search = [searchField text];
	if(!loadingAnotherPage && [search isEqual:lastSearch]) return;
	if(!loadingAnotherPage) [page reset];
	[app showServiceIndicator];
	if(switchedService && !loadingAnotherPage) {
		if([table dataSource]) [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:false];
		[page reset];
	}
	if(![search isEqual:lastSearch]) {
		GDRelease(lastSearch);
		lastSearch = [search copy];
		[page reset];
	}
	[self serviceStart];
	[self selectButton:nil];
	GDRelease(searchService);
	searchService = [[ACSearchService serviceWithQuery:search andOffset:[page offset] andLimit:[page limit]] retain];
	[searchService setUseCache:false];
	[searchService setFinished:GDCreateCallback(self,searchFinished) andFailed:GDCreateCallback(self,searchFailed)];
	[searchService sendAsync];
}

- (void) searchFinished {
	[app hideServiceIndicator];
	refresh = kACExploreRefreshTypeSearch;
	serviceData = [[searchService data] retain];
	serviceTotalRows = [[searchService totalRows] retain];
	[self serviceComplete];
	[self reloadTableData];
	GDRelease(searchService);
}

- (void) searchFailed {
	GDRelease(lastSearch);
	refresh = kACExploreRefreshTypeNone;
	lastSearch = nil;
	[app hideServiceIndicator];
	[self serviceComplete];
	[data removeAllItemsInSection:0];
	[data addItem:[ACGalleryRowCellData dataForCellType:kCellTypeNoResults] toSection:0];
	[table setDataSource:data];
	[table reloadData];
	GDRelease(searchService);
}

- (void) serviceStart {
	addARCells = false;
	[[self view] findAndResignFirstResonder];
	GDRelease(serviceData);
	GDRelease(serviceTotalRows);
}

- (void) serviceComplete {
	loadingAnotherPage = false;
}

- (void) reloadTableData {
	ACGalleryRowCellData * d;
	[page setTotalRows:serviceTotalRows];
	addARCells = false;
	saveNearbyData = false;
	if([serviceTotalRows intValue] > 0) {
		if([[page offset] intValue] == 0) [data removeAllItemsInSection:0];
		NSInteger count = [serviceData count];
		[page addMoreAvailable:count];
		ARCell * cell;
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
		NSNumber * lat;
		NSNumber * lon;
		NSNumber * userId;
		NSDictionary * item;
		CLLocation * location;
		CLLocationDegrees latit;
		CLLocationDegrees longi;
		int r;
		int rc;
		float b;
		for(i;i<count;i++) {
			item = [serviceData objectAtIndex:i];
			tagId = [item objectForKey:@"tagId"];
			userId = [item objectForKey:@"userId"];
			lat = [item objectForKey:@"latitude"];
			lon = [item objectForKey:@"longitude"];
			latit = (CLLocationDegrees)[lat doubleValue];
			longi = (CLLocationDegrees)[lon doubleValue];
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
			if(largeURL) largeURL = [ACServicesHelper getS3FilepathFromFileName:largeURL];
			if(thumbURL) thumbURL = [ACServicesHelper getS3FilepathFromFileName:thumbURL];
			r = [rating intValue];
			rc = [rateCount intValue];
			if(r < 1) r = 1;
			if(rc < 1) rc = 1;
			b = (float)r / (float)rc;
			rated = ceil(b);
			d = [ACGalleryRowCellData rowWithTagId:tagId large:largeURL thumb:thumbURL title:username rating:rated andTagCount:tagCount];
			[d setUid:userId];
			[d setCelltype:kCellTypeExplore];
			[d setThoroughfare:thoroughfare subThoroughfare:subThoroughfare locality:locality subLocality:subLocality];
			[d setAdministrativeArea:administrativeArea subAdministrativeArea:subAdministrativeArea postalcode:postalcode country:country];
			[d setLargeFilename:largeFilename andThumbFilename:thumbFilename];
			[data addItem:d toSection:0];
			if(saveNearbyData) [lastNearbyData addObject:d];
			if(addARCells) {
				location = [[CLLocation alloc] initWithLatitude:latit longitude:longi];
				cell = [[ARCell alloc] initWithNibName:@"ARCell" bundle:nil];
				[cell setData:d];
				[cell setDelegate:self];
				[ar addARView:cell withLocation:location];
				[cell release];
				[location release];
			}
		}
		if([serviceData count] >= 25) [data addItem:[ACGalleryRowCellData dataForCellType:kCellTypeMore] toSection:0];
		//if(([page available] < [[page totalRows] longValue])) [data addItem:[ACGalleryRowCellData dataForCellType:kCellTypeMore] toSection:0];
	} else if([serviceTotalRows intValue] == 0 && [data countOfItemsInSection:0] > 0) {
		[data removeAllItemsInSection:0];
		[data addItem:[ACGalleryRowCellData dataForCellType:kCellTypeNoResults] toSection:0];
	} else if([data countOfItemsInSection:0] > 0) {
	} else {
		[data removeAllItemsInSection:0];
		[data addItem:[ACGalleryRowCellData dataForCellType:kCellTypeNoResults] toSection:0];
	}
	[table setDataSource:data];
	[table reloadData];
}

- (void) selectButton:(UIButton *) button {
	[selectedButton setSelected:false];
	selectedButton = button;
	[selectedButton setSelected:true];
}

- (void) prepareFrame {
	
}

- (void) viewDidGoIn {
	if(!hasLoadedDefaultNearby) [self performNearby];
}

- (void) viewDidGoOut {
	
}

- (void) viewDidLoad {
	hasLoadedDefaultNearby = false;
	loadingAnotherPage = false;
	switchedService = true;
	refresh = kACExploreRefreshTypeNone;
	app = [ACAppController sharedInstance];
	ar = [[ARViewController alloc] initWithNibName:@"ARViewController" bundle:nil];
	viewer = [[ACTagViewer alloc] initWithNibName:@"TagViewer" bundle:nil];
	data = [[ACTableDataSourceController alloc] init];
	page = [[ACServicePage alloc] init];
	lastNearbyData = [[NSMutableArray alloc] init];
	onCellPressed = [GDCreateCallback(self,onCellPressed:) retain];
	onMorePressed = [GDCreateCallback(self,onLoadMorePressed) retain];
	onDeletePressed = [GDCreateCallback(self,deleteCell:) retain];
	serviceTotalRows = [[NSNumber numberWithInt:0] retain];
	user = [ACUserInfo sharedInstance];
	canUseAR = [app isHeadingAvailable];
	selectedButton = nearbyButton;
	[ar setDelegate:self];
	[data addSection];
	[viewer setShowUsername:true];
	[data setOnCellPressed:onCellPressed];
	[data setOnMorePressed:onMorePressed];
	if([user god]) [data setOnDeleteSwiped:onDeletePressed];
}

- (void) viewDidUnload {
	refresh = kACExploreRefreshTypeNone;
	[ar removeAllViews];
	[ar setDelegate:nil];
	[viewer setData:nil];
	[viewer setSelectedItem:nil];
	[table setDataSource:nil];
	GDRelease(ar);
	GDRelease(viewer);
	GDRelease(serviceData);
	GDRelease(lastNearbyData);
	GDRelease(serviceTotalRows);
	GDRelease(lastSearch);
	selectedButton = nil;
	GDRelease(nearbyButton);
	GDRelease(latestButton);
	GDRelease(ratingButton);
	GDRelease(arButton);
	GDRelease(table);
	GDRelease(onCellPressed);
	GDRelease(onMorePressed);
	GDRelease(onDeletePressed);
	GDRelease(searchField);
	app = nil;
	[data setOnCellPressed:nil];
	[data setOnMorePressed:nil];
	GDRelease(data);
	GDRelease(page);
	GDRelease(searchService);
	GDRelease(nearbyService);
	GDRelease(latestService);
	GDRelease(ratingService);
	GDRelease(arNearbyService);
	GDRelease(deletingData);
	user = nil;
	[super viewDidUnload];
}

- (void) unloadView {
	[self setView:nil];
}

- (void) didReceiveMemoryWarning {
	if(![[self view] superview]) [self unloadView];
    [super didReceiveMemoryWarning];
}

- (void) dealloc {
	[self unloadView];
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACExplore");
	#endif
	[super dealloc];
}

@end
