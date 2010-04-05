//
//  CVAbstractImageProcessingPlugIn.h
//  VisualObjectTracker
//
//  Created by Mirek Rusin on 19/02/2010.
//  Copyright 2010 Inteliv Ltd. All rights reserved.
//

#import "QCCVPlugIn.h"
#import "QCCVIplImageProvider.h"

@interface QCCVAbstractInputImageProcessingPlugIn : QCCVPlugIn {
  NSString *pixelFormat;
  BOOL lockBufferRepresentation;
  
  id<QCPlugInInputImageSource> inputImage;
  IplImage *inputIplImage;
  
  id<QCPlugInOutputImageProvider> outputImage;
  IplImage *outputIplImage;
  QCCVIplImageProvider *outputIplImageProvider;
}

@property (assign) id<QCPlugInInputImageSource> inputImage;
@property (assign) id<QCPlugInOutputImageProvider> outputImage;

- (QCCVAbstractInputImageProcessingPlugIn *) init;
- (QCCVAbstractInputImageProcessingPlugIn *) initWithPixelFormat: (NSString *) pixelFormat_ lockBufferRepresentation: (BOOL) lockBufferRepresentation_;

- (BOOL) ifDifferentUpdateOutputIplImageWithCloneOfInputImage: (id<QCPlugInInputImageSource>) image;
- (BOOL) ifDifferentUpdateInputIplImageWithInputImage: (id<QCPlugInInputImageSource>) image;

@end

@interface QCCVAbstractInputImageProcessingPlugIn (ImageProcessingExecution)

- (BOOL) executeImageProcessingWith: (id<QCPlugInContext>) context atTime: (NSTimeInterval) time withArguments: (NSDictionary*) arguments;
                                                                                                                        
@end

