
#import "QCCVCanny.h"

@implementation QCCVCanny

@dynamic inputFirstThreshold;
@dynamic inputSecondThreshold;
@dynamic inputApertureSizeIndex;

@dynamic inputImage;
@dynamic outputImage;

- (id) init {
  if (self = [super init]) {
    useImageIntensity = YES;
  }
  return self;
}

@end

@implementation QCCVCanny (ImageProcessingExecution)

- (BOOL) executeImageProcessingWith: (id<QCPlugInContext>) context atTime: (NSTimeInterval) time withArguments: (NSDictionary*) arguments {
  NSUInteger apertureSize = [QCCVPlugIn apertureSizeValueWithIndex: self.inputApertureSizeIndex];
  cvCanny(inputIplImageIntensity, outputIplImageIntensity, self.inputFirstThreshold, self.inputSecondThreshold, apertureSize);
  //NSLog(@"%@ %@", [QCCVPlugIn detailsWithIplImage: inputIplImageIntensity], [QCCVPlugIn detailsWithIplImage: outputIplImageIntensity]);
  [QCCVPlugIn convertGRAY: outputIplImageIntensity toRGBA: outputIplImage];
  self.outputImage = outputIplImageProvider;
  return YES;
}

@end