
#import "ACViewStack.h"

@implementation ACViewStack

- (id) initWithContainerView:(UIView *) containerView {
	if(!(self = [super init])) return nil;
	_containerView = [containerView retain];
	_views = [[NSMutableArray alloc] init];
	return self;
}

- (void) prepareView:(UIViewController <ACViewStackDelegate> *) vc {
	if(![vc isViewLoaded])  {
		[vc loadView];
		[vc viewDidLoad];
	}
}

- (void) destroyView:(UIViewController <ACViewStackDelegate> *) vc {
	if([vc isViewLoaded]) {
		[vc unloadView];
		[vc viewDidUnload];
	}
}

- (void) pushViewController:(UIViewController *) vc_in animated:(Boolean) animated {
	if(!vc_in) return;
	if(!([_views indexOfObject:vc_in] == NSNotFound)) {
		NSLog(@"A view controller cannot be pushed more than once into the same view stack");
		return;
	}
	UIViewController <ACViewStackDelegate> * vc_out = _currentViewController;
	UIViewController <ACViewStackDelegate> * vc_in_d = vc_in;
	[self prepareView:vc_in];
	if(animated) {
		if(vc_out) {
			//animate vc_out (<-)
		}
		//animate vc_in (<-)
	} else {
		@synchronized(vc_out) {
			[[vc_out view] removeFromSuperview];
			[vc_out viewDidGoOut];
		}
		@synchronized(vc_in) {
			[vc_in_d prepareFrame];
			[_containerView addSubview:[vc_in view]];
			[vc_in_d viewDidGoIn];
		}
	}
	[_views addObject:vc_in];
	_currentViewController=vc_in;
}

- (void) popViewControllerAnimated:(Boolean) animated {
	if([_views count] < 2) return;
	[_views removeLastObject];
	UIViewController <ACViewStackDelegate> * vc_out = _currentViewController;
	UIViewController <ACViewStackDelegate> * vc_in = [_views lastObject];
	if(animated) {
		if(vc_in && vc_out) {
			//animate vc_out (->)
			//animate vc_in (->)
		}
	} else {
		@synchronized(vc_out) {
			[[vc_out view] removeFromSuperview];
			[vc_out viewDidGoOut];
		}
		@synchronized(vc_in) {
			[vc_in prepareFrame];
			[_containerView addSubview:[vc_in view]];
			[vc_in viewDidGoIn];
		}
	}
	_currentViewController=vc_in;
	[self destroyView:vc_out];
}

- (void) dealloc {
	GDRelease(_containerView);
	GDRelease(_views);
	_currentViewController = nil;
	#ifdef ACNSLogDealloc
	NSLog(@"DEALLOC ACViewStack");
	#endif
	[super dealloc];
}

@end
