
#import <Cocoa/Cocoa.h>

#import "QCCVAbstractInputImageProcessingPlugIn.h"

@interface QCCVLaplace : QCCVAbstractInputImageProcessingPlugIn {
  NSUInteger inputApertureSizeIndex;
}

@property (assign) NSUInteger inputApertureSizeIndex;

@end
