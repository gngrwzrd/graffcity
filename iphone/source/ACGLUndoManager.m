#import "ACGLUndoManager.h"



@implementation ACGLUndoManager

@synthesize buffer;
@synthesize bufferSize;
@synthesize undoAvailable;

- (id)initWithWidth:(float)w andHeight:(float)h{
	self = [super init];

	NSString *home = NSHomeDirectory();
	NSString *file = [home stringByAppendingPathComponent:@"Documents/undo.ints"];
	const char *cf = [file UTF8String];
	int fd = open(cf, O_RDONLY,S_IRWXU|S_IRWXO|S_IRWXG);
	if(fd < 0){
		printf("no file setup reverting to defaults \n");
		undoLevel = 0;
		totalUndos = 0;
	}else{
		struct undostate *saveData = malloc(sizeof(struct undostate));
		read(fd, saveData, sizeof(struct undostate));
		undoLevel = saveData->undoLevel;
		totalUndos = saveData->totalUndos;
		free(saveData);
	}
	close(fd);
	undoAvailable = totalUndos > 1;
	bufferSize = (w * h * 4);
	buffer = malloc(bufferSize);
	memset(buffer, 1, bufferSize);
	return self;
}

- (GLubyte*)loadSavedState{
	// printf("loading initial image from %d \n", undoLevel);
	NSString * home = NSHomeDirectory();
	NSString *fileName = [NSString stringWithFormat: @"Documents/undo_%d.bits", undoLevel];
	NSString * file = [home stringByAppendingPathComponent:fileName];
	const char * cf = [file UTF8String];
	int fd = open(cf,O_RDONLY,S_IRWXU|S_IRWXO|S_IRWXG);
	if(fd < 0) {
		perror("could not open last saved  image\n");
		for(int i=0; i<bufferSize; i++){
			buffer[i] = 0;
		}
		return (GLubyte*)buffer;
	}
	read(fd, buffer, bufferSize);
	close(fd);
	undoAvailable = totalUndos > 1;
	return (GLubyte*)buffer;
}

- (void)saveUndo{
	undoLevel ++;
	if(undoLevel > kNumUndos){
		undoLevel = 0;
	}
	totalUndos ++;
	if(totalUndos > kNumUndos){
		totalUndos = kNumUndos;
	}
	undoAvailable = totalUndos > 1;
	NSString *home = NSHomeDirectory();
	NSString *fileName = [NSString stringWithFormat: @"Documents/undo_%d.bits", undoLevel];
	NSString *file = [home stringByAppendingPathComponent:fileName];
	const char * cf = [file UTF8String];
	int fd = open(cf,O_CREAT|O_TRUNC|O_WRONLY,S_IRWXU|S_IRWXO|S_IRWXG);
	if(fd < 0) {
		perror("file open error\n");
		return;
	}
	write(fd, buffer, bufferSize);
	
	// Uncomment to make sure data is coming in.
	/* 
	int numPixels = 0;
	for(int i=0; i<bufferSize; i++){
		if(buffer[i] > 0) numPixels ++;
	}
	if(numPixels == 0){
		printf("!!! WARNING: %d PIXELS WERE LOGGED IN THE UNDO SAVE \n", numPixels);
	}
	*/
	
	
	close(fd);
	// printf("saving undo from %d num undos is: %d \n", undoLevel, totalUndos);
	[self logDefaults];
}

- (void)logDefaults{
	struct undostate *saveData = malloc(sizeof(struct undostate));
	saveData->undoLevel = undoLevel;
	saveData->totalUndos = totalUndos;
	NSString *home = NSHomeDirectory();
	NSString *file = [home stringByAppendingPathComponent:@"Documents/undo.ints"];
	const char * cf = [file UTF8String];
	int fd = open(cf, O_CREAT|O_TRUNC|O_WRONLY,S_IRWXU|S_IRWXO|S_IRWXG);
	if(fd < 0) {
		perror("could not open file to log undos\n");
		return;
	}
	write(fd, saveData, sizeof(struct undostate));
	close(fd);
	free(saveData);
	printf("save undos: %d %d\n", saveData->undoLevel, saveData->totalUndos);
}


- (GLubyte*)loadUndo{
	NSString * home = NSHomeDirectory();
	undoLevel --;
	if(undoLevel - 1 < 0){
		undoLevel = kNumUndos;
	}
	totalUndos --;
	printf("loading undo from %d num undos is: %d \n", undoLevel, totalUndos);
	NSString *fileName = [NSString stringWithFormat: @"Documents/undo_%d.bits", undoLevel];
	NSString * file = [home stringByAppendingPathComponent:fileName];
	const char * cf = [file UTF8String];
	int fd = open(cf,O_RDONLY,S_IRWXU|S_IRWXO|S_IRWXG);
	if(fd < 0) {
		perror("file open error");
		return 0;
	}
	read(fd, buffer, bufferSize);
	close(fd);
	// check if the next undo is invalid
	undoAvailable = totalUndos > 1;
	[self logDefaults];
	return (GLubyte*)buffer;
}

- (void)reset{
	undoLevel = 0;
	totalUndos = 0;
	for(int i=0; i<bufferSize; i++){
		buffer[i] = 0;
	}
	[self saveUndo];
	undoAvailable = false;
	[self logDefaults];
}

- (void)dealloc{
	[self logDefaults];
	free(buffer);
	[super dealloc];
}

@end
