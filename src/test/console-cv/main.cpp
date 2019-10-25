#include <QCoreApplication>
#include <iostream>
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>

using namespace cv;
using namespace std;

int main(int argc, char *argv[])
{
    Q_UNUSED(argc)
    Q_UNUSED(argv)

    String imgName{"../common/sjl.jpg"};
    Mat img = imread(samples::findFile(imgName),IMREAD_COLOR);
    if(img.empty()) {
        cout << "Could not find the image" << endl;
    }

    namedWindow("Show Image", WINDOW_AUTOSIZE);
    imshow("Show Image",img);
    waitKey(0);

    return 0;
}
