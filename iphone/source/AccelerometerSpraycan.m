
#import "AccelerometerSpraycan.h"

static short accelsstep = 64;
static float pixelScale = 0.03;
static double mps = 9.8;
static double ppm = 3779.527559055;

static void processFilteredAccelerations(long count, double * fin, double * fout) {
	int dir = 0;
	int lastdir = 0;
	long i = 0;
	long j = 0;
	long totalChanges = 0;
	long lastchange = 0;
	long changediff = 0;
	long spikeindex = 0;
	double spike = 0;
	double abs_filtered_accel = 0;
	double filtered_accel;
	double filtered_accel2;
	bool changes[count];
	bool removes[count];
	bool spikes[count];
	memset(changes,0,sizeof(bool) * count);
	memset(removes,0,sizeof(bool) * count);
	memset(spikes,0,sizeof(bool) * count);
	
	for(i=0; i<count; i++) { //find changes
		filtered_accel = fin[i];
		if(filtered_accel == 0) continue;
		if(filtered_accel < 0) dir = -1;
		if(filtered_accel > 0) dir = 1;
		if(dir != lastdir) {
			changes[i] = true;
			totalChanges++;
		}
		lastdir = dir;
	}
	
	lastchange = 0;
	for(i=0; i<count; i++) { //find changes that occured to quickly and remove them.
		if(changes[i]) {
			changediff = i - lastchange;
			if(changediff < 5 && i > 0) {
				totalChanges--;
				for(j = 0;j < changediff ;j++) removes[lastchange+j] = 1;
			}
			lastchange = i;
		}
	}
	
	lastchange = 0;
	for(i=0; i<count; i++) { //make sure changes are still consistent after removes.
		filtered_accel = fin[i];
		if(filtered_accel == 0 || removes[i]) continue;
		if(changes[i] && i == 0) lastchange = 0;
		if(changes[i] && i > 0) {
			j = i-1;
			for(j; j>lastchange; j--) { //go up, make sure previous change is different sign.
				if(removes[j]) continue;
				filtered_accel2 = fin[j];
				if((filtered_accel > 0 && filtered_accel2 > 0) || (filtered_accel < 0 && filtered_accel2 < 0)) {
					changes[i] = false;
					totalChanges--;
					break;
				}
			}
			lastchange = i;
		}
	}
	
	for(i=0; i<count; i++) { //find spikes
		filtered_accel = fin[i];
		if(filtered_accel == 0 || removes[i]) continue;
		abs_filtered_accel = fabs(filtered_accel);
		if(changes[i] && i == 0) spike = abs_filtered_accel;
		if(changes[i] && i > 0) {
			spikes[spikeindex] = true;
			spike = 0;
		}
		if(abs_filtered_accel > spike) {
			spikeindex = i;
			spike = abs_filtered_accel;
		}
	}
	
	if(spikeindex > 0) spikes[spikeindex] = true; //record last spike
	
	for(i=0; i<count; i++) { //now write to the fout array
		if(removes[i]) fout[i] = 0;
		else fout[i] = fin[i];
	}
}

@implementation AccelerometerSpraycan
@synthesize coords;
@synthesize startPoint;

- (id) init {
	if(!(self = [super init])) return nil;
	paused = true;
	accelwall = 0;
	accelcount = 0;
	accelstotal = 250;
	xfiltered_in = NULL;
	xfiltered_out = NULL;
	yfiltered_in = NULL;
	yfiltered_out = NULL;
	accelcoords = NULL;
	startPoint = CGPointMake(160,240);
	accels = calloc(accelstotal,sizeof(UIAcceleration *));
	highFilter = [[AccelerometerHighpassFilter alloc] initWithSampleRate:kUpdateFrequency cutoffFrequency:kCutoffFrequency];
	[[ACAccelerometer sharedInstance] registerTarget:self forAccelerometerEventCallback:@selector(accelerometerDidAccelerate:)];
	return self;
}

- (void) accelerometerDidAccelerate:(UIAcceleration *) acceleration {
	if(paused) return;
	if(accelwall < 20) {
		accelwall++;
		return;
	}
	if(accelcount == accelstotal) {
		accelstotal += accelsstep;
		accels = realloc(accels,sizeof(UIAcceleration *) * accelstotal);
	}
	accels[accelcount] = [acceleration retain];
	accelcount++;
}

- (void) processAccelerations {
	//NSLog(@"processAccelerations");
	long i = 0;
	double x,y;
	//double z;
	float xmin = -0.05;
	float xmax = 0.05;
	float ymin = -0.05;
	float ymax = 0.05;
	UIAcceleration * accel = NULL;
	struct accelcoord * coord = NULL;
	struct accelcoord * pcoord = NULL;
	if(accelcoords) free(accelcoords);
	if(xfiltered_in) free(xfiltered_in);
	if(yfiltered_in) free(yfiltered_in);
	accelcoords = calloc(accelcount,sizeof(struct accelcoord *));
	xfiltered_in = calloc(accelcount,sizeof(double));
	yfiltered_in = calloc(accelcount,sizeof(double));
	for(i; i < accelcount; i++) {
		accel = accels[i];
		coord = calloc(1,sizeof(struct accelcoord));
		[highFilter addAcceleration3D:accel];
		x = [highFilter x];
		y = [highFilter y];
		//z = [highFilter z];
		if(x < 0 && x > xmin) x = 0;
		if(x > 0 && x < xmax) x = 0;
		if(y < 0 && y > ymin) y = 0;
		if(y > 0 && y < ymax) y = 0;
		xfiltered_in[i] = x;
		yfiltered_in[i] = y;
		//coord->acceleration[0] = x;
		//coord->acceleration[1] = y;
		coord->acceleration[2] = [highFilter z];
		coord->timestamp = accel.timestamp;
		coord->timediff = (pcoord) ? coord->timestamp - pcoord->timestamp : 0;
		accelcoords[i] = coord;
		pcoord = coord;
	}
}

- (void) processAccelCoords {
	//NSLog(@"processAccelCoords");
	if(xfiltered_out) free(xfiltered_out);
	if(yfiltered_out) free(yfiltered_out);
	xfiltered_out = calloc(accelcount,sizeof(double));
	yfiltered_out = calloc(accelcount,sizeof(double));
	processFilteredAccelerations(accelcount,xfiltered_in,xfiltered_out);
	processFilteredAccelerations(accelcount,yfiltered_in,yfiltered_out);
	long i = 0;
	struct accelcoord * coord;
	for(; i<accelcount; i++) {
		coord = accelcoords[i];
		if(xfiltered_in[i] == 0) coord->acceleration[0] = 0;
		else  coord->acceleration[0] = xfiltered_out[i];
		if(yfiltered_in[i] == 0) coord->acceleration[1] = 0;
		else coord->acceleration[1] = yfiltered_out[i];
	}
}

- (void) processPoints {
	//NSLog(@"processPoints");
	long i = 0;
	if(points) free(points);
	points = calloc(accelcount,sizeof(CGPoint));
	struct accelcoord * coord;
	struct accelcoord * pcoord;
	for(; i<accelcount; i++) {
		coord = accelcoords[i];
		pcoord = accelcoords[i-1];
		if(i == 0) {
			coord->xpixels = 0;
			coord->ypixels = 0;
			coord->point.x = startPoint.x;
			coord->point.y = startPoint.y;
		} else {
			double xgs = coord->acceleration[0];
			double ygs = coord->acceleration[1];
			if(xgs == 0) coord->xpixels = 0;
			if(ygs == 0) coord->ypixels = 0;
			if(xgs != 0 && ygs != 0) {
				double xmps = xgs * mps; //x meters per second
				double ymps = ygs * mps; //y meters per second
				double xMetersInTimeLapse = xmps * coord->timediff; //x meters in time lapse
				double yMetersInTimeLapse = ymps * coord->timediff; //y meters in time lapse
				double xPixelsInTimeLapse = (xMetersInTimeLapse * ppm); //number of x pixels in time lapse
				double yPixelsInTimeLapse = (yMetersInTimeLapse * ppm); //number of y pixels in time lapse
				coord->xpixels = xPixelsInTimeLapse * pixelScale;
				coord->ypixels = yPixelsInTimeLapse * pixelScale;
			}
			coord->point.x = pcoord->point.x + coord->xpixels;
			coord->point.y = pcoord->point.y - coord->ypixels;
			//coord->point.y = pcoord->point.y + 0;
			points[i] = coord->point;
		}
		//NSLog(@"Point: x:%g, y:%g", coord->point.x, coord->point.y);
	}
}

- (void) cleanup {
	//NSLog(@"cleanup");
	long i = 0;
	if(accels) {
		for(i=0;i<accelcount;i++) {
			[accels[i] release];
			accels[i] = NULL;
		}
	}
	if(accelcoords) {
		for(i=0;i<accelcount;i++) free(accelcoords[i]);
		free(accelcoords);
		accelcoords = NULL;
	}
}

- (long) count {
	return accelcount;
}

- (CGPoint *) points {
	return points;
}

- (void) begin {
	paused = false;
	accelwall = 0;
	accelcount = 0;
}

- (void) end {
	paused = true;
	[self processAccelerations];
	[self processAccelCoords];
	[self processPoints];
	[self cleanup];
}

- (void) dealloc {
	[[ACAccelerometer sharedInstance] unregisterTarget:self forAccelerometerEventCallback:@selector(accelerometerDidAccelerate:)];
	GDRelease(coords);
	GDRelease(highFilter);
	if(points) free(points);
	if(xfiltered_in) free(xfiltered_in);
	if(yfiltered_in) free(yfiltered_in);
	if(xfiltered_out) free(xfiltered_out);
	if(yfiltered_out) free(yfiltered_out);
	if(accelcoords) free(accelcoords);
	if(accels) free(accels);
	accels = NULL;
	accelcoords = NULL;
	xfiltered_in = NULL;
	xfiltered_out = NULL;
	yfiltered_in = NULL;
	yfiltered_out = NULL;
	points = NULL;
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC AccelerometerSpraycan");
	#endif
	[super dealloc];
}

@end

/*
i = 0;
for(coord in coords) {
filteredx = filteredx = filteredxs[i];
if(filteredx == 0) {
i++;
continue;
}
if(removes[i] && changes[i]) totalChanges--;
printf("%03lu : (",i);
if(filteredx < 0) printf("<,");
else printf(">,");
if(removes[i]) printf("r,");
else printf(" ,");
if(!removes[i]) printf("A,");
else printf(" ,");
if(changes[i] && !removes[i]) printf("c,");
else printf(" ,");
if(spikes[i]) printf("s,");
else printf(" ,");
printf(") : ");
printf("%g",filteredx);
printf("\n");
i++;
}
*/


/*
[highFilter addAcceleration3D:acceleration];
 AccelerometerSpraycanCoordinate * coord = [[AccelerometerSpraycanCoordinate alloc] init];
 [coord setPrev:prev];
 if(prev) [prev setNext:coord];
 [coord setTimestamp:acceleration.timestamp];
 [coord setAccelerationX:acceleration.x y:acceleration.y z:acceleration.z];
 [coord setFilteredAcceleration:[highFilter x] y:[highFilter y] z:[highFilter z]];
 if([coord isHead]) {
 //startPoint = [prev point];
 startPoint = CGPointMake(160,240);
 [coord setPoint:startPoint];
 }
 [coords addObject:coord];
 [coord release];
 prev = coord;
*/

/*
 - (void) updateAllCoordsForX:(Boolean) _x orY:(Boolean) _y {
 if(_x) NSLog(@"Updating For X");
 if(_y) NSLog(@"Updating For Y");
 int dir = 0;
 int lastdir = 0;
 long i = 0;
 long j = 0;
 long totalChanges = 0;
 long lastchange = 0;
 long changediff = 0;
 long spikeindex = 0;
 long count = [coords count];
 double spike = 0;
 double abs_filtered_accel = 0;
 double filtered_accel;
 double filtered_accel2;
 double filtered_accels[count];
 bool changes[count];
 bool removes[count];
 bool spikes[count];
 memset(changes,0,sizeof(bool) * count);
 memset(filtered_accels,0,sizeof(bool) * count);
 memset(removes,0,sizeof(bool) * count);
 memset(spikes,0,sizeof(bool) * count);
 AccelerometerSpraycanCoordinate * coord;
 
 for(coord in coords) { //find changes
 if(_x) filtered_accel = [coord filteredAccelerationX];
 else filtered_accel = [coord filteredAccelerationY];
 filtered_accels[i] = filtered_accel;
 if(filtered_accel == 0) {
 i++;
 continue;
 }
 if(filtered_accel < 0) dir = -1;
 if(filtered_accel > 0) dir = 1;
 if(dir != lastdir) {
 changes[i] = true;
 totalChanges++;
 }
 i++;
 lastdir = dir;
 }
 
 i = 0;
 for(coord in coords) { //remove changes that occured to quickly
 filtered_accel = filtered_accels[i];
 if(filtered_accel == 0) {
 i++;
 continue;
 }
 if(changes[i]) {
 changediff = i - lastchange;
 if(changediff < 5 && i > 0) {
 totalChanges--;
 for(j = 0;j < changediff ;j++) removes[lastchange+j] = 1;
 }
 lastchange = i;
 }
 i++;
 }
 
 i = 0;
 lastchange = 0;
 for(coord in coords) { //make sure changes are still consistent after removes.
 filtered_accel = filtered_accels[i];
 if(filtered_accel == 0 || removes[i]) {
 i++;
 continue;
 }
 if(changes[i] && i == 0) lastchange = 0;
 if(changes[i] && i > 0) {
 j = i-1;
 for(j; j > lastchange; j--) { //go up, make sure previous change is different sign.
 if(removes[j]) continue;
 filtered_accel2 = filtered_accels[j];
 if((filtered_accel > 0 && filtered_accel2 > 0) || (filtered_accel < 0 && filtered_accel2 < 0)) {
 changes[i] = false;
 totalChanges--;
 break;
 }
 }
 lastchange = i;
 }
 i++;
 }
 
 i = 0;
 for(coord in coords) { //find spikes
 filtered_accel = filtered_accels[i];
 if(filtered_accel == 0 || removes[i]) {
 i++;
 continue;
 }
 abs_filtered_accel = fabs(filtered_accel);
 if(changes[i] && i == 0) spike = abs_filtered_accel;
 if(changes[i] && i > 0) {
 spikes[spikeindex] = true;
 spike = 0;
 }
 if(abs_filtered_accel > spike) {
 spikeindex = i;
 spike = abs_filtered_accel;
 }
 i++;
 }
 
 
 if(spikeindex > 0) spikes[spikeindex] = true;
 
 NSLog(@"totalChanges: %i",totalChanges);
 
 i = 0;
 NSMutableArray * newcoords = [[NSMutableArray alloc] init];
 AccelerometerSpraycanCoordinate * prv = nil;
 for(coord in coords) {
 if(removes[i]) {
 if(_x) [coord setXpixels:0];
 else [coord setYpixels:0];
 continue;
 }
 [coord setPrev:prv];
 if(prv) [prv setNext:coord];
 [coord invalidate];
 [newcoords addObject:coord];
 prv = coord;
 i++;
 }
 [coords release];
 coords = newcoords;
 }
 
 - (AccelerometerSpraycanCoordinate *) head {
 if([coords count] < 1) return nil;
 return [coords objectAtIndex:0];
 }
 
 - (AccelerometerSpraycanCoordinate *) tail {
 return [coords lastObject];
 }
 
*/