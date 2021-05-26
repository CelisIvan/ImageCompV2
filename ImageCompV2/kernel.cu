
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "CompareImageCUDA.h"

__global__ void CompareCUDA(unsigned char* img, int channels);

void ImageCompareCUDA(unsigned char* inputImage, int height, int width, int channels) {
	unsigned char* devInputImage = NULL;
	cudaMalloc((void**)&devInputImage, height * width * channels);

	cudaMemcpy(devInputImage, inputImage, height * width * channels, cudaMemcpyHostToDevice);
	dim3 gridImage(width , height);

	CompareCUDA << <gridImage,1  >> > (devInputImage, channels);


	cudaMemcpy(inputImage, devInputImage, height * width * channels, cudaMemcpyDeviceToHost);

	cudaFree(devInputImage);
}

__global__ void CompareCUDA(unsigned char* img, int channels) {
	// int id = (threadIdx.x + blockIdx.x * blockDim.x) * channels;
	int x = blockIdx.x;
	int y = blockIdx.y;
	int id = (x + y * gridDim.x) * channels;


	for (int i = 0; i < channels; i++) {
		img[id + i] = 255 - img[id + i];
	}

}