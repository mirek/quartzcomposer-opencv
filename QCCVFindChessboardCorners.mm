//
//  QCCVFindChessboardCorners.m
//  OpenCV
//
//  Created by Mirek Rusin on 05/04/2010.
//  Copyright 2010 Inteliv Ltd. All rights reserved.
//

#import "QCCVFindChessboardCorners.h"

@implementation QCCVFindChessboardCorners

- (BOOL) ifDifferentUpdateInputIplImageWithInputImage: (id<QCPlugInInputImageSource>) image {
  BOOL didChange = NO;
  if (didChange = [super ifDifferentUpdateInputIplImageWithInputImage: image]) {
    if (inputIplImageIntensity != NULL) {
      cvReleaseImage(&inputIplImageIntensity);
    }
    inputIplImageIntensity = cvCreateImage(cvSize(inputIplImage->width, inputIplImage->height), 8, 1);
  }
  [QCCVPlugIn convertRGBA: inputIplImage toGRAY: inputIplImageIntensity];
  //cvCvtColor(inputIplImage, inputIplImageIntensity, CV_RGBA2GRAY);
  return didChange;
}

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
