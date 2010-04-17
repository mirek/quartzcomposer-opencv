
#import "QCCVSobel.h"

@implementation QCCVSobel

@dynamic inputApertureSizeIndex;

@dynamic inputImage;
@dynamic outputImage;

@end

@implementation QCCVSobel (ImageProcessingExecution)

///
/// cvSobel accepts 8U (a) or 32F (b) source depths and 16S, 32F (a) or 32F (b) destination depths.
/// So we're always doing producting 32F destination from 8U or 32F source.
///
- (BOOL) executeImageProcessingWith: (id<QCPlugInContext>) context atTime: (NSTimeInterval) time withArguments: (NSDictionary*) arguments {
  //NSUInteger apertureSize = [QCCVPlugIn apertureSizeValueWithIndex: self.inputApertureSizeIndex];
  
  //cvSobel(, <#CvArr *dst#>, <#int xorder#>, <#int yorder#>, <#int aperture_size#>)(inputIplImage, outputIplImage32F, apertureSize);
  
  //for (int i = 0; i < outputIplImage32F
  //((float *)(img->imageData + i*img->widthStep))[j*img->nChannels + 3] = 1.0f
  
//  int sn = outputIplImage32F->width * outputIplImage32F->height * outputIplImage32F->nChannels;
//  float *s = (float *)(outputIplImage32F->imageData);
//  for (int i = 0; i < sn; i += 4)
//    s[i + 3] = 1.0f;
//  
//  //((float *)(img->imageData + i*img->widthStep))[j*img->nChannels + 0]
//  
//  self.outputImage = [[QCCVIplImageProvider alloc] initWithIplImageReference: &outputIplImage32F];
  return YES;
}

@end
