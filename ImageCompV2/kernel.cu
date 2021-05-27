#include <iostream>
#include <stdio.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "CompareImageCUDA.h"

#include <cstdlib>

__global__ void compare_CUDA(unsigned char* image, unsigned char* image2, unsigned char* image3, int channels, int option);

void Image_Comparisson_CUDA(unsigned char* inputImage, unsigned char* inputImage2, unsigned char* diffImage, int height, int width, int channels, int option) {
	unsigned char* Dev_Input_Image = NULL;
	unsigned char* Dev_Input_Image2 = NULL;
	unsigned char* Dev_outputImage = NULL;
	//allocate
	cudaMalloc((void**)&Dev_Input_Image, height * width * channels);
	cudaMalloc((void**)&Dev_Input_Image2, height * width * channels);
	cudaMalloc((void**)&Dev_outputImage, height * width * channels);

	//copy data from cpu to gpu
	cudaMemcpy(Dev_Input_Image, inputImage, height * width * channels, cudaMemcpyHostToDevice);
	cudaMemcpy(Dev_Input_Image2, inputImage2, height * width * channels, cudaMemcpyHostToDevice);
	cudaMemcpy(Dev_outputImage, diffImage, height * width * channels, cudaMemcpyHostToDevice);


	dim3 gridImage(width * height / 512);

	// compare_CUDA << <gridImage, 3 >> > (Dev_Input_Image, Dev_Input_Image2, Dev_outputImage, channels);
	compare_CUDA << <gridImage, 512 >> > (Dev_Input_Image, Dev_Input_Image2, Dev_outputImage, channels, option);


	cudaMemcpy(inputImage, Dev_Input_Image, height * width * channels, cudaMemcpyDeviceToHost);
	cudaMemcpy(inputImage2, Dev_Input_Image2, height * width * channels, cudaMemcpyDeviceToHost);
	cudaMemcpy(diffImage, Dev_outputImage, height * width * channels, cudaMemcpyDeviceToHost);

	cudaFree(Dev_Input_Image);
	cudaFree(Dev_Input_Image2);
	cudaFree(Dev_outputImage);
}

__global__ void compare_CUDA(unsigned char* image, unsigned char* image2, unsigned char* image3, int channels, int option) {
	//int y = blockIdx.y;
	int id = (threadIdx.x + blockIdx.x * blockDim.x) * channels;

	//col = ThreadIdx.x + BlockIdx.x * BlockDim.x;
	//row = BlockIdx.y;

	if (option == 1) {
		for (int i = 0; i < channels; i++) {
			if (image[id + i] != image2[id + i]) {
				image3[id + i] = 255 - image[id + i];
			}
			else {
				image3[id + i] = 0;
			}

		}
	}
	else {
		for (int i = 0; i < channels; i++) {
			int dif = abs(image[id + i] - image2[id + i]);
			if (dif > 90) {
				image3[id + i] = 255 - image[id + i];
			}
			else {
				image3[id + i] = 0;
			}
		}
	}
}
