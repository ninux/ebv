#include <stdio.h>

int main(char argc, char** argv)
{
	int r = 169;
	int g = 186;
	int b = 112;

	int y  = (( 306)*r + ( 601)*g + ( 117)*b) >> 10;
	int cb = ((-173)*r + (-339)*g + ( 512)*b) >> 10;
	int cr = (( 512)*r + (-429)*g + ( -83)*b) >> 10;

	printf("\nRGB\tR  = %i\n\tG  = %i\n\tB  = %i\n", r, g, b);
	printf("\nYCbCr\tY  = %i\n\tCb = %i\n\tCr = %i\n", y, cb, cr);

	return 0;
}
