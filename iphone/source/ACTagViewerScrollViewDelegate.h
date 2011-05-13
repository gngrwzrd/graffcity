
@class ACTagViewerScrollView;

@protocol ACTagViewerScrollViewDelegate

- (void) scrollViewWantsControlsShown:(ACTagViewerScrollView *) scrollView;
- (void) scrollViewDidBeginTouches:(ACTagViewerScrollView *) scrollView;
- (void) scrollViewDidMoveTouches:(ACTagViewerScrollView *) scrollView;

@end
