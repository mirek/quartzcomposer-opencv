//
//  QCCVIntensityImageProvider.h
//  VisualObjectTracker
//
//  Created by Mirek Rusin on 20/02/2010.
//  Copyright 2010 Inteliv Ltd. All rights reserved.
//

#import <Quartz/Quartz.h>

@interface QCCVIntensityImageProvider : NSObject <QCPlugInOutputImageProvider> {
  id<QCPlugInInputImageSource> _image;
  NSString *_pixelFormat;
}

- (id) initWithImageSource: (id<QCPlugInInputImageSource>) image;
- (void) updateIfNecessaryWithInputImageSource: (id<QCPlugInInputImageSource>) image;

@end
