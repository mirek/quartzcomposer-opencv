
#import "QCCVFindChessboardCorners.h"

@implementation QCCVFindChessboardCorners

@end

@implementation QCCVFindChessboardCorners (ImageProcessingExecution)

- (BOOL) executeImageProcessingWith: (id<QCPlugInContext>) context atTime: (NSTimeInterval) time withArguments: (NSDictionary *) arguments {
  CvSize boardSize = cvSize(9, 7);
  CvPoint2D32f *corners = (CvPoint2D32f *)calloc(sizeof(CvPoint2D32f), 9 * 7);
  int cornerCount = 0;
  int found = cvFindChessboardCorners(inputIplImage,
                                      boardSize,
                                      corners,
                                      &cornerCount,
                                      CV_CALIB_CB_ADAPTIVE_THRESH | CV_CALIB_CB_FILTER_QUADS);
  if (found) {
    
  }
  //cvFindChessboardCorners(inputIplImage, pattern_size, corners, corner_count, flags_);
  //cvThreshold(inputIplImage, outputIplImage, self.inputThreshold, self.inputMaxValue, self.inputThresholdType);
  //self.outputImage = outputIplImageProvider;
  return YES;
}

@end
