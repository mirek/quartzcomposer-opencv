//
//  CVAbstractImageProcessingPlugIn.m
//  VisualObjectTracker
//
//  Created by Mirek Rusin on 19/02/2010.
//  Copyright 2010 Inteliv Ltd. All rights reserved.
//

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

- (QCCVAbstractInputImageProcessingPlugIn *) init {
  return [self initWithPixelFormat: QCPlugInPixelFormatBGRA8 lockBufferRepresentation: YES];
}

- (QCCVAbstractInputImageProcessingPlugIn *) initWithPixelFormat: (NSString *) pixelFormat_ lockBufferRepresentation: (BOOL) lockBufferRepresentation_ {
  if (self = [super init]) {
    pixelFormat = pixelFormat_;
    lockBufferRepresentation = lockBufferRepresentation_;
    outputIplImageProvider = [[QCCVIplImageProvider alloc] initWithIplImageReference: &outputIplImage];
  }
  return self;
}

- (BOOL) ifDifferentUpdateInputIplImageWithInputImage: (id<QCPlugInInputImageSource>) image {
  BOOL didChange = NO;
  if (![QCCVPlugIn isIplImage: inputIplImage sameAsInputImageSource: image]) {
    if (inputIplImage != NULL)
      cvReleaseImageHeader(&inputIplImage);
    inputIplImage = [QCCVPlugIn createIplImageHeaderWithInputImageSource: image];
    didChange = YES;
  }
  if (inputIplImage) 
    inputIplImage->imageData = (char *)[image bufferBaseAddress];
  return didChange;
}

- (BOOL) ifDifferentUpdateOutputIplImageWithCloneOfInputImage: (id<QCPlugInInputImageSource>) image {
  BOOL didChange = NO;
  if (![QCCVPlugIn isIplImage: outputIplImage sameAsInputImageSource: image]) {
    if (outputIplImage != NULL)
      cvReleaseImage(&outputIplImage);
    outputIplImage = [QCCVPlugIn cloneIplImageWithInputImageSource: image];
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