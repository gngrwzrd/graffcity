
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "macros.h"

@interface ACSoundManager : NSObject {
	AVAudioPlayer *player;
}

@property(nonatomic, retain) AVAudioPlayer * player;

@end
