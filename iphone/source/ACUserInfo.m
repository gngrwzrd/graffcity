
#import "ACUserInfo.h"

static ACUserInfo * inst;

@implementation ACUserInfo
@synthesize password;
@synthesize email;
@synthesize username;
@synthesize uid;
@synthesize god;

+ (ACUserInfo *) sharedInstance {
	@synchronized(self) {
		if(!inst) inst = [[self alloc] init];
	}
	return inst;
}

- (id) init {
	if(!(self = [super init])) return nil;
	defaults = [NSUserDefaults standardUserDefaults];
	username = [[defaults objectForKey:@"ACUserInfo.username"] copy];
	email = [[defaults objectForKey:@"ACUserInfo.email"] copy];
	password = [[defaults objectForKey:@"ACUserInfo.password"] copy];
	uid = [[defaults objectForKey:@"ACUserInfo.id"] copy];
	return self;
}

- (BOOL) isLoggedIn {
	return (username && password);
}

- (void) logout {
	[self unregister];
}

- (void) setUsername:(NSString *) _username email:(NSString *) _email andPassword:(NSString *) _password {
	[self setUsername:_username];
	[self setEmail:_email];
	[self setPassword:_password];
	//[defaults synchronize];
}

- (void) setPassword:(NSString *) _password {
	if(![_password isEqual:password]) {
		[password release];
		password = [_password retain];
		[defaults setObject:password forKey:@"ACUserInfo.password"];
	}
}

- (void) setEmail:(NSString *) _email {
	if(![_email isEqual:email]) {
		[email release];
		email = [_email retain];
		[defaults setObject:email forKey:@"ACUserInfo.email"];
	}
}

- (void) setUsername:(NSString *) _username {
	if(![_username isEqual:email]) {
		[username release];
		username = [_username retain];
		[defaults setObject:username forKey:@"ACUserInfo.username"];
	}
}

- (void) setUid:(NSNumber *) _uid {
	if(![_uid isEqualToNumber:uid]) {
		[uid release];
		uid = [_uid retain];
		[defaults setObject:uid forKey:@"ACUserInfo.id"];
	}
}

- (void) unregister {
	[self setUsername:nil];
	[self setPassword:nil];
	[self setEmail:nil];
	[self setUid:nil];
	[defaults removeObjectForKey:@"ACUserInfo.username"];
	[defaults removeObjectForKey:@"ACUserInfo.email"];
	[defaults removeObjectForKey:@"ACUserInfo.password"];
	[defaults removeObjectForKey:@"ACUserInfo.id"];
	[defaults synchronize];
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

- (void) dealloc {
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACUserInfo");
	#endif
	GDRelease(email);
	GDRelease(username);
	GDRelease(password);
	GDRelease(uid);
	defaults = nil;
	[super dealloc];
}

@end
