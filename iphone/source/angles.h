
#import "math.h"
#import <CoreGraphics/CoreGraphics.h>

NS_INLINE double DegreesToRadians(double degrees) {
	double radians = degrees * (M_PI/180);
	return radians;
}

NS_INLINE double RadiansToDegrees(double radians) {
	double degrees = degrees * (M_PI/180);
	return degrees;
}

NS_INLINE CGPoint GetPointFromAngle(double angle, double distance){
	float angleRads = DegreesToRadians(angle);
	return CGPointMake(sin(angleRads) * distance, cos(angleRads) * distance);
}

NS_INLINE double GetDistanceBetweenPoints(CGPoint point1, CGPoint point2){
	double distance = sqrt(pow( (point1.x-point2.x), 2)+pow( (point1.y-point2.y), 2));
	return distance;
}

NS_INLINE double GetAngleBetweenPoints(CGPoint point1, CGPoint point2){
	double angle = atan2(point2.y - point1.y, point2.x - point1.x) * 180 / M_PI;
	return angle;
}

NS_INLINE double NormalizeDegrees(double degrees) {
	while(degrees < 0){
		degrees += 360;
	}
	while (degrees > 360) {
		degrees -= 360;
	}
	return degrees;
}