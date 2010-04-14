
#import "QCCVDilate.h"

@implementation QCCVDilate

@dynamic inputIterations;

@dynamic inputImage;
@dynamic outputImage;

@end

@implementation QCCVDilate (ImageProcessingExecution)

- (BOOL) executeImageProcessingWith: (id<QCPlugInContext>) context atTime: (NSTimeInterval) time withArguments: (NSDictionary*) arguments {
  cvDilate(inputIplImage, outputIplImage, NULL, self.inputIterations);
  self.outputImage = outputIplImageProvider;
  return YES;
}

@end