
#include <iostream>
#include <stdio.h>
#include <opencv2/opencv.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>

#include "CompareImageCUDA.h"

using namespace std;
using namespace cv;

int main() {

	Mat InputImage = imread("Testimage.png");

	cout << "Height:" << InputImage.rows << "Width" << InputImage.cols;

	ImageCompareCUDA(InputImage.data, InputImage.rows, InputImage.cols, InputImage.channels());

	imwrite("InvertedImage.png", InputImage);

	system("pause");

	return 0;
}