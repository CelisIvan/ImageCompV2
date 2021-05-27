#ifndef _CompareImageCUDA_
#define _CompareImageCUDA_
void Image_Comparisson_CUDA(unsigned char* inputImage, unsigned char* inputImage2, unsigned char* diffImage, int height, int width, int channels, int option);
#endif
