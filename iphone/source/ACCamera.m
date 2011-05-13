#import "ACCamera.h"
#import "ACAppController.h"

@implementation ACCamera
@synthesize container;
- (void)viewDidGoIn{
	app = [ACAppController sharedInstance];
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
		hascam = true;
	}
	if(hascam) {
		camera = [[UIImagePickerController alloc] init];
		[camera setSourceType:UIImagePickerControllerSourceTypeCamera];
		[camera setShowsCameraControls:false];
		[camera setDelegate:self];
		[camera setNavigationBarHidden:true];
		[camera setToolbarHidden:true];
		[camera setAllowsEditing:false];
		[camera setCameraOverlayView:self.view];
		if([app is40SDK]) [camera setCameraViewTransform:CGAffineTransformMakeScale(1.25,1.25)];
		else [camera setCameraViewTransform:CGAffineTransformMakeScale(1.15,1.15)];
		[self showCam];
		viewingCam = true;
	}
	NSLog(@"Add cam on view in");
}

- (void)takePicture{
	if(viewingCam){
		[camera takePicture];
	}else{
		[self imageRecievedFromTakePicture:snappedView.image];
	}
}

- (void)imageRecievedFromTakePicture:(UIImage*)pickerImage{
	
}

- (void)prepareFrame{
}

- (void)unloadView{
	self.view = nil;
}

- (IBAction)toggleCamera{
	if(viewingCam && hascam){
		viewingCam = false;
		[camera takePicture];
	}else if(hascam){
		if(snappedView != nil){
			[snappedView removeFromSuperview];
			GDRelease(snappedView);
		}
		[self showCam];
		viewingCam = true;
	}
	printf("TOGGLE CAMERA \n");
}

- (void)imagePickerController:(UIImagePickerController *) picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	[self hideCam];
	UIImage *pickerImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	PXRImageLib *imgLib = [[[PXRImageLib alloc] init] autorelease];
	UIImage *img = [imgLib rotateAndScaleCameraImage:pickerImage withSize:CGSizeMake(kCameraResolutionWidth, kCameraResolutionHeight) usingType:@""];
	if(!viewingCam){
		snappedView = [[UIImageView alloc] initWithImage:img];
		[self.view addSubview:snappedView];
		[self.view insertSubview:snappedView atIndex:0];
		// resize to fit
		float perX = (float)kDrawBoardPixelWidth/(float)kCameraResolutionWidth;
		float perY = (float)kDrawBoardPixelHeight/(float)kCameraResolutionHeight;
		

		if(perX > perY){
			snappedView.transform = CGAffineTransformScale(snappedView.transform, perX, perX);
		}else{
			snappedView.transform = CGAffineTransformScale(snappedView.transform, perY, perY);
		}
		snappedView.center = CGPointMake(kDrawBoardPixelWidth/2, kDrawBoardPixelHeight/2);
	}else{
		[self imageRecievedFromTakePicture:img];
	}
}

- (void)showCam{
	if(hascam){
		if(snappedView != nil){
			[snappedView removeFromSuperview];
			GDRelease(snappedView);
		}
		[self presentModalViewController:camera animated:false];
		camera.view.center = CGPointMake(kDrawBoardPixelWidth/2, kDrawBoardPixelHeight/2);
	}
}

- (void)hideCam{
	if(hascam){
		[self dismissModalViewControllerAnimated:false];
	}
}

- (void)viewDidGoOut{
	if(snappedView != nil){
		[snappedView removeFromSuperview];
		GDRelease(snappedView);
	}
	[self hideCam];
	camera.delegate = nil;
	GDRelease(camera);
	NSLog(@"Remove cam on view out");
}


- (void)dealloc {
    [super dealloc];
}


@end
