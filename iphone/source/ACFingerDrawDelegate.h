
@class ACFingerDrawing;

@protocol ACFingerDrawDelegate

- (void) imageDidFinishLogging:(ACFingerDrawing *) fingerDrawing;
- (void) userBeganDrawing:(ACFingerDrawing *) fingerDrawing;

@end
