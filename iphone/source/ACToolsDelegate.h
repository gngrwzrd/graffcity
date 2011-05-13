
@class ACTools;

@protocol ACToolsDelegate

- (void) tools:(ACTools *) tools didSelectBrush:(NSString *) brushName;
- (void) tools:(ACTools *) tools didChangeBrushSize:(float) brushSize;
- (void) tools:(ACTools *) tools didChangeDripLength:(float) dripLength;
- (void) tools:(ACTools *) tools didToggleDripState:(Boolean) dripState;
- (void) tools:(ACTools *) tools didChangeColor:(UIColor*) color;

@end