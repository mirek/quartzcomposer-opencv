
#import "QCCVPlugIn.h"
#import "QCCVIplImageProvider.h"

@interface QCCVAbstractInputImageProcessingPlugIn : QCCVPlugIn {
  id<QCPlugInInputImageSource> inputImage;
  IplImage *inputIplImage;
  
  id<QCPlugInOutputImageProvider> outputImage;
  IplImage *outputIplImage;
  QCCVIplImageProvider *outputIplImageProvider;
  
  // When YES automatically updates to and from image intensity
  // TODO: add QCCV_INTENSITY_INPUT, QCCV_INTENSITY_OUTPUT
  BOOL useImageIntensity;
  IplImage *inputIplImageIntensity;
  IplImage *outputIplImageIntensity;
}

@property (assign) id<QCPlugInInputImageSource> inputImage;
@property (assign) id<QCPlugInOutputImageProvider> outputImage;

- (id) init;

- (BOOL) ifDifferentUpdateOutputIplImageWithCloneOfInputImage: (id<QCPlugInInputImageSource>) image;
- (BOOL) ifDifferentUpdateInputIplImageWithInputImage: (id<QCPlugInInputImageSource>) image;

@end

@interface QCCVAbstractInputImageProcessingPlugIn (ImageProcessingExecution)

- (BOOL) executeImageProcessingWith: (id<QCPlugInContext>) context atTime: (NSTimeInterval) time withArguments: (NSDictionary*) arguments;
                                                                                                                        
@end

