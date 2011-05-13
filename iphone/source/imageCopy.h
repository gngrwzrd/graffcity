
#import "math.h"
#import "macros.h"
#import <Foundation/Foundation.h>

void CompositeImage(unsigned char *src, unsigned char *dest, int srcW, int srcH);
void CompositeImage2(unsigned char *src, unsigned char *dest, CGRect srcRect, CGRect destRect, CGRect transformRect);