
#include <iostream>
#include <stdio.h>
#include <opencv2/opencv.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <string.h>

#include "CompareImageCUDA.h"

using namespace std;
using namespace cv;

int main() {

	string imag1, imag2;
	int res;
	cout << "Select a comparisson option:\n1. Hard\n2.Shape" << endl;
	cin >> res;
	cout << "Image1 name(png): " << endl;
	cin >> imag1;

	cout << "Image2 name: (png) " << endl;
	cin >> imag2;

	Mat inputImage = imread(imag1);
	Mat inputImage2 = imread(imag2);

	if (res == 1) {
		
		Mat diffImage = inputImage.clone();
		cout << "Height: " << inputImage.rows << "\nWIDTH: " << inputImage.cols << endl;

		Image_Comparisson_CUDA(inputImage.data, inputImage2.data, diffImage.data, inputImage.rows, inputImage.cols, inputImage.channels(), 1);
		imwrite("InvertedImage.png", diffImage);

		system("pause");
	}
	else {
		Mat imgGrayscale;        // grayscale of input image
		Mat imgBlurred;            // intermediate blured image
		Mat imgCanny;

		Mat imgGrayscale2; 
		Mat imgBlurred2;            
		Mat imgCanny2;

		cvtColor(inputImage, imgGrayscale, COLOR_BGR2GRAY);
		cvtColor(inputImage2, imgGrayscale2, COLOR_BGR2GRAY);

		GaussianBlur(imgGrayscale, imgBlurred, Size(5, 5), 1.5);
		GaussianBlur(imgGrayscale2, imgBlurred2, Size(5, 5), 1.5);

		Canny(imgBlurred, imgCanny, 100, 200);
		Canny(imgBlurred2, imgCanny2, 100, 200);

		Mat diffImage = imgCanny.clone();
		Image_Comparisson_CUDA(imgCanny.data, imgCanny2.data, diffImage.data, imgCanny.rows, imgCanny2.cols, imgCanny.channels(), 2);
		imwrite("InvertedImage.png", diffImage);

		system("pause");
	}

	return 0;
}