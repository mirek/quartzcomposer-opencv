// TODO:
// * change ifDifferent... to ignore format. Only the size, to implement...
// * forcing format of the output image (needed for laplace which requires output to be 16 or 32 bits)

#import "QCCVAbstractInputImageProcessingPlugIn.h"

@implementation QCCVAbstractInputImageProcessingPlugIn

@dynamic inputImage;
@dynamic outputImage;

+ (QCPlugInExecutionMode) executionMode {
	return kQCPlugInExecutionModeProcessor;
}

+ (QCPlugInTimeMode) timeMode {
	return kQCPlugInTimeModeNone;
}

- (id) init {
  if (self = [super init]) {
    outputIplImageProvider = [[QCCVIplImageProvider alloc] initWithIplImageReference: &outputIplImage];
  }
  return self;
}

- (BOOL) ifDifferentUpdateInputIplImageWithInputImage: (id<QCPlugInInputImageSource>) image {
  BOOL didChange = NO;
  if (![QCCVPlugIn isIplImage: inputIplImage sameSizeAndFormatAsInputImageSource: image]) {
    if (inputIplImage != NULL)
      cvReleaseImageHeader(&inputIplImage);
    inputIplImage = [QCCVPlugIn createIplImageHeaderWithInputImageSource: image];
    
    // Recreate image intensity if we're using it as well
    if (useImageIntensity) {
      if (inputIplImageIntensity != NULL)
        cvReleaseImage(&inputIplImageIntensity);
      inputIplImageIntensity = cvCreateImage(cvSize(inputIplImage->width, inputIplImage->height), 8, 1);
    }
    
    didChange = YES;
  }
  if (inputIplImage)
    inputIplImage->imageData = (char *)[image bufferBaseAddress];
  return didChange;
}

- (BOOL) ifDifferentUpdateOutputIplImageWithCloneOfInputImage: (id<QCPlugInInputImageSource>) image {
  BOOL didChange = NO;
  if (![QCCVPlugIn isIplImage: outputIplImage sameSizeAndFormatAsInputImageSource: image]) {
    if (outputIplImage != NULL)
      cvReleaseImage(&outputIplImage);
    outputIplImage = [QCCVPlugIn cloneIplImageWithInputImageSource: image];
    
    // Recreate output for image intensity if we're using it
    if (useImageIntensity) {
      if (outputIplImageIntensity != NULL)
        cvReleaseImage(&outputIplImageIntensity);
      outputIplImageIntensity = cvCreateImage(cvSize(inputIplImage->width, inputIplImage->height), 8, 1);
    }
    
    didChange = YES;
  }
  return didChange;
}

@end

@implementation QCCVAbstractInputImageProcessingPlugIn (ImageProcessingExecution)

- (BOOL) executeImageProcessingWith: (id<QCPlugInContext>) context atTime: (NSTimeInterval) time withArguments: (NSDictionary*) arguments {
  return YES;
}

@end


@implementation QCCVAbstractInputImageProcessingPlugIn (Execution)

- (BOOL) startExecution: (id<QCPlugInContext>) context {
	return YES;
}

- (void) enableExecution: (id<QCPlugInContext>) context {
}

- (BOOL) execute: (id<QCPlugInContext>) context atTime: (NSTimeInterval) time withArguments: (NSDictionary *) arguments {
  BOOL r = NO;
  if ([self didValueForInputKeyChange: @"inputImage"]) {
    id<QCPlugInInputImageSource> inputImage_ = self.inputImage;
    if (inputImage_ == nil) {
      [context logMessage: @"Input image is nil"];
      r = YES;
    } else {
      
      NSString *pixelFormat;
      CGColorSpaceRef colorSpace = [inputImage_ imageColorSpace];
      if (CGColorSpaceGetModel(colorSpace) == kCGColorSpaceModelMonochrome) {
        pixelFormat = QCPlugInPixelFormatI8;
      } else if (CGColorSpaceGetModel(colorSpace) == kCGColorSpaceModelRGB) {
#if __BIG_ENDIAN__
        pixelFormat = QCPlugInPixelFormatARGB8;
#else
        pixelFormat = QCPlugInPixelFormatBGRA8;
#endif
      } else {
        [context logMessage: @"Unable to get proper pixel format to lock buffer representation"];
        return NO;
      }
      
      if (![inputImage_ lockBufferRepresentationWithPixelFormat: pixelFormat
                                                     colorSpace: [inputImage_ imageColorSpace]
                                                      forBounds: [inputImage_ imageBounds]]) {
        [context logMessage:
         @"Can't lock buffer representation with pixel format %@, color space %@ and image bounds %@",
         [inputImage_ bufferPixelFormat],
         [inputImage_ imageColorSpace],
         [inputImage_ imageBounds]];
        r = NO;
      } else {
        
        [self ifDifferentUpdateInputIplImageWithInputImage: inputImage_];
        
        // Update image intensity if we're using it
        if (useImageIntensity)
          [QCCVPlugIn convertRGBA: inputIplImage toGRAY: inputIplImageIntensity];
        
        [self ifDifferentUpdateOutputIplImageWithCloneOfInputImage: inputImage_];
        
        //NSLog(@" * %p %p", inputIplImage, outputIplImage);
        
        r = [self executeImageProcessingWith: context atTime: time withArguments: arguments];
        
        if (r == NO) {
          [context logMessage: @"OpenCV patch says NO!", inputImage_];
        }
        
        [inputImage_ unlockBufferRepresentation];
      }
    }
  } else {
    r = YES;
  }
	return r;
}

- (void) disableExecution:(id<QCPlugInContext>)context {
}

- (void) stopExecution:(id<QCPlugInContext>)context {
}

@end