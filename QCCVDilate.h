
#import "QCCVAbstractInputImageProcessingPlugIn.h"

@interface QCCVDilate : QCCVAbstractInputImageProcessingPlugIn {
  NSUInteger inputIterations;
}

@property (assign) NSUInteger inputIterations;

@end
