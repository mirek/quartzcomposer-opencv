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
  return [self initWithPixelFormat: QCPlugInPixelFormatBGRA8 lockBufferRepresentation: YES];
}

- (id) initWithPixelFormat: (NSString *) pixelFormat_ lockBufferRepresentation: (BOOL) lockBufferRepresentation_ {
  if (self = [super init]) {
    pixelFormat = pixelFormat_;
    lockBufferRepresentation = lockBufferRepresentation_;
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

- (BOOL) execute: (id<QCPlugInContext>) context atTime: (NSTimeInterval) time withArguments: (NSDictionary*) arguments {
  BOOL r = NO;
  if ([self didValueForInputKeyChange: @"inputImage"]) {
    id<QCPlugInInputImageSource> inputImage_ = self.inputImage;
    if (inputImage_ == nil) {
      NSLog(@" * input image is null");
      r = YES;
    } else {
      if (![inputImage_ lockBufferRepresentationWithPixelFormat: pixelFormat
                                                     colorSpace: [inputImage_ imageColorSpace]
                                                      forBounds: [inputImage_ imageBounds]]) {
        NSLog(@" * cant lock buffer");
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
          NSLog(@"* returned NO");
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