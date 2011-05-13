
#include "accelerometer_math.h"
#include <math.h>

double clamp(double num, double min, double max) {
	if(num > max) return max;
	else if(num < min) return min;
	else return num;
}

double norm2D(double x, double y) {
	return sqrt((x*x) + (y*y));
}

double norm3D(double x, double y, double z) {
	return sqrt(x*x + y*y + z*z);
}
