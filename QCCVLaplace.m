
#import "QCCVLaplace.h"

@implementation QCCVLaplace

@dynamic inputApertureSizeIndex;

@dynamic inputImage;
@dynamic outputImage;

- (BOOL) ifDifferentUpdateOutputIplImageWithCloneOfInputImage: (id<QCPlugInInputImageSource>) image {
  BOOL didChange = NO;
  if (didChange = [super ifDifferentUpdateOutputIplImageWithCloneOfInputImage: image]) {
    if (outputIplImage32F != NULL)
      cvReleaseImage(&outputIplImage32F);
    outputIplImage32F = cvCreateImage(cvSize(inputIplImage->width, inputIplImage->height), IPL_DEPTH_32F, inputIplImage->nChannels);
  }
  return didChange;
}

@end

@implementation QCCVLaplace (ImageProcessingExecution)

///
/// cvLaplace accepts 8U (a) or 32F (b) source depths and 16S, 32F (a) or 32F (b) destination depths.
/// So we're always doing producting 32F destination from 8U or 32F source.
///
- (BOOL) executeImageProcessingWith: (id<QCPlugInContext>) context atTime: (NSTimeInterval) time withArguments: (NSDictionary*) arguments {
  NSUInteger apertureSize = [QCCVPlugIn apertureSizeValueWithIndex: self.inputApertureSizeIndex];
  
  cvLaplace(inputIplImage, outputIplImage32F, apertureSize);
  
  //for (int i = 0; i < outputIplImage32F
  //((float *)(img->imageData + i*img->widthStep))[j*img->nChannels + 3] = 1.0f
  
  int sn = outputIplImage32F->width * outputIplImage32F->height * outputIplImage32F->nChannels;
  float *s = (float *)(outputIplImage32F->imageData);
  for (int i = 0; i < sn; i += 4)
    s[i + 3] = 1.0f;
  
  //((float *)(img->imageData + i*img->widthStep))[j*img->nChannels + 0]
  
  self.outputImage = [[QCCVIplImageProvider alloc] initWithIplImageReference: &outputIplImage32F];
  return YES;
}

@end
