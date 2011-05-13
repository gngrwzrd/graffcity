
#include "imageCopy.h"

void CompositeImage(unsigned char *src, unsigned char *dest, int srcW, int srcH){
	int w = srcW;
	int h = srcH;
	
	int px0;
	int px1;
	int px2;
	int px3;
	
	int inverseAlpha;
	
	int r;
	int g;
	int b;
	int a;
	
	int y;
	int x;
	
	for (y = 0; y < h; y++) {
        for (x= 0; x< w*4; x+=4) {
            // pixel number
            px0 = (y*w*4) + x;
            px1 = (y*w*4) + (x+1);
            px2 = (y*w*4) + (x+2);
			px3 = (y*w*4) + (x+3);
			
			inverseAlpha = 255 - src[px3];
			
			// create new values
			r = src[px0]  + inverseAlpha * dest[px0]/255;
			g = src[px1]  + inverseAlpha * dest[px1]/255;
			b = src[px2]  + inverseAlpha * dest[px2]/255;
			a = src[px3]  + inverseAlpha * dest[px3]/255;
			
			// update destination image
			dest[px0] = r;
			dest[px1] = g;
			dest[px2] = b;
			dest[px3] = a;
        }
    }
}

void CompositeImage2(unsigned char *src, unsigned char *dest, CGRect srcRect, CGRect destRect, CGRect transformRect){
	//clock_t c1,c2;
	int register w = floor(transformRect.size.width);
	int register h = floor(transformRect.size.height);
	int register wMod;
	int register hMod;
	int register srcBase;
	int register destBase;
	int register srcMult;
	int register destMult;
	int register y;
	int register x;
	int register trnsX = floor(transformRect.origin.x);
	int register trnsY = floor(transformRect.origin.y);
	int register srcWidth = floor(srcRect.size.width);
	int register destW = destRect.size.width;
	int register inverseAlpha;
	int register r;
	int register g;
	int register b;
	int register a;
	int register ds0;
	int register ds1;
	int register ds2;
	int register ds3;
	int register sc3;
	float register scaleX = srcRect.size.width/transformRect.size.width;
	float register scaleY = srcRect.size.height/transformRect.size.height; //
	y = 0;
	//c1 = clock();
	for(; y < h; y++) {
		hMod = floor(y * scaleY);
		//srcMult = (hMod) * srcWidth * 4;
		//destMult = (y + trnsY) * destW * 4;
		srcMult = (hMod * srcWidth) << 2; // (<< 2) == (* 4)
		destMult = ((y + trnsY) * destW) << 2;
        for (x= 0; x < w; x++) {
			wMod = floor(x * scaleX);
			//srcBase = srcMult + (wMod) * 4; //the index of the source to use
			srcBase = srcMult + ((wMod) << 2);
			sc3 = srcBase+3;
			//destBase = destMult + (x + trnsX) * 4; //the index of the destination to use
			destBase = destMult + ((x + trnsX) << 2);
			ds0 = destBase;
			ds1 = destBase+1;
			ds2 = destBase+2;
			ds3 = destBase+3;
			inverseAlpha = 255 - src[sc3]; //create new values
			r = src[srcBase] + inverseAlpha * dest[ds0]/255;
			g = src[srcBase+1] + inverseAlpha * dest[ds1]/255;
			b = src[srcBase+2] + inverseAlpha * dest[ds2]/255;
			a = src[sc3] + inverseAlpha * dest[ds3]/255;
			dest[ds0] = r; //update destination image
			dest[ds1] = g;
			dest[ds2] = b;
			dest[ds3] = a;
		}
	}
	//c2 = clock();
	//GDPrintClockDifference("CompositeImage2 took",c1,c2);
}
