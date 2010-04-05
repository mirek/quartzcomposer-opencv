//
//  QCCVImageIntensity.m
//  VisualObjectTracker
//
//  Created by Mirek Rusin on 20/02/2010.
//  Copyright 2010 Inteliv Ltd. All rights reserved.
//

#import "QCCVImageIntensity.h"

@implementation QCCVImageIntensity

@dynamic inputImage;
@dynamic outputImage;

- (QCCVImageIntensity *) init {
  if (self = [super init]) {
    _outputImage = [[QCCVIntensityImageProvider alloc] initWithImageSource: nil];
  }
  return self;
}

+ (QCPlugInExecutionMode) executionMode {
	return kQCPlugInExecutionModeProcessor;
}

+ (QCPlugInTimeMode) timeMode {
	return kQCPlugInTimeModeNone;
}

@end

@implementation QCCVImageIntensity (Execution)

- (BOOL) startExecution: (id<QCPlugInContext>) context {
	return YES;
}

- (void) enableExecution: (id<QCPlugInContext>) context {
}

- (BOOL) execute: (id<QCPlugInContext>) context atTime: (NSTimeInterval) time withArguments: (NSDictionary*) arguments {
  if ([self didValueForInputKeyChange: @"inputImage"]) {
    id<QCPlugInInputImageSource> inputImage_ = self.inputImage;
    if (inputImage_ == nil) {
      return NO;
    } else {
      [_outputImage updateIfNecessaryWithInputImageSource: inputImage_];
      self.outputImage = _outputImage;
    }
  }
	return YES;
}

- (void) disableExecution:(id<QCPlugInContext>)context {
}

- (void) stopExecution:(id<QCPlugInContext>)context {
}

@end
