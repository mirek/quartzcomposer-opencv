
#import "QCCVLaplace.h"

@implementation QCCVLaplace

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

@implementation QCCVLaplace (ImageProcessingExecution)

// ((src.depth() == CV_8U && (dst.depth() == CV_16S || dst.depth() == CV_32F))
//  (src.depth() == CV_32F && dst.depth() == CV_32F)))
- (BOOL) executeImageProcessingWith: (id<QCPlugInContext>) context atTime: (NSTimeInterval) time withArguments: (NSDictionary*) arguments {
  NSUInteger apertureSize = [QCCVPlugIn apertureSizeValueWithIndex: self.inputApertureSizeIndex];
  IplImage *tmp = cvCreateImage(cvSize(inputIplImage->width, inputIplImage->height), 32, inputIplImage->nChannels);
  
  NSLog(@"* Laplace with %@ and %@",
        [QCCVPlugIn detailsWithIplImage: inputIplImageIntensity],
        [QCCVPlugIn detailsWithIplImage: tmp]);
  
  cvLaplace(inputIplImage, tmp, apertureSize);
  
  //cvCvtColor(outputImage, , <#int code#>)
  self.outputImage = [[QCCVIplImageProvider alloc] initWithIplImageReference: &tmp];
  return YES;
}

@end
