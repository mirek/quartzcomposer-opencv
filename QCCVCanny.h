//
//  QCCVCanny.h
//  VisualObjectTracker
//
//  Created by Mirek Rusin on 20/02/2010.
//  Copyright 2010 Inteliv Ltd. All rights reserved.
//

#import "QCCVAbstractInputImageProcessingPlugIn.h"

@interface QCCVCanny : QCCVAbstractInputImageProcessingPlugIn {
  double inputFirstThreshold;
  double inputSecondThreshold;
  NSUInteger inputApertureSize;
  
  IplImage *inputIplImageIntensity;
  IplImage *outputIplImageIntensity;
}

@property (assign) double inputFirstThreshold;
@property (assign) double inputSecondThreshold;
@property (assign) NSUInteger inputApertureSize;

@end
