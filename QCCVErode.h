
#import "QCCVAbstractInputImageProcessingPlugIn.h"

@interface QCCVErode : QCCVAbstractInputImageProcessingPlugIn {
  NSUInteger inputIterations;
}

@property (assign) NSUInteger inputIterations;

@end
