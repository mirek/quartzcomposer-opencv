//
//  QCCVImageIntensity.h
//  VisualObjectTracker
//
//  Created by Mirek Rusin on 20/02/2010.
//  Copyright 2010 Inteliv Ltd. All rights reserved.
//

#import <Quartz/Quartz.h>
#import "QCCVIntensityImageProvider.h"


@interface QCCVImageIntensity : QCPlugIn {
  id<QCPlugInInputImageSource> inputImage;
  id<QCPlugInOutputImageProvider> outputImage;
  QCCVIntensityImageProvider *_outputImage;
}

@property (assign) id<QCPlugInInputImageSource> inputImage;
@property (assign) id<QCPlugInOutputImageProvider> outputImage;

@end
