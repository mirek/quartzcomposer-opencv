
#import "QCCVErode.h"

@implementation QCCVErode

@dynamic inputIterations;

@dynamic inputImage;
@dynamic outputImage;

@end

@implementation QCCVErode (ImageProcessingExecution)

- (BOOL) executeImageProcessingWith: (id<QCPlugInContext>) context atTime: (NSTimeInterval) time withArguments: (NSDictionary*) arguments {
  cvErode(inputIplImage, outputIplImage, NULL, self.inputIterations);
  self.outputImage = outputIplImageProvider;
  return YES;
}

@end