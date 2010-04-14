
#import "QCCVAbstractInputImageProcessingPlugIn.h"

@interface QCCVCanny : QCCVAbstractInputImageProcessingPlugIn {
  double inputFirstThreshold;
  double inputSecondThreshold;
  NSUInteger inputApertureSizeIndex;
}

@property (assign) double inputFirstThreshold;
@property (assign) double inputSecondThreshold;
@property (assign) NSUInteger inputApertureSizeIndex;

@end
