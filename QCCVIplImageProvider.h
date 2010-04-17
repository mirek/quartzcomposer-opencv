///
///  CVIplImageProvider.h
///  VisualObjectTracker
///
///  Created by Mirek Rusin on 19/02/2010.
///  Copyright 2010 Inteliv Ltd. All rights reserved.
///

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>
//#import <OpenCV/OpenCV.h>
#import <opencv/cv.h>

@interface QCCVIplImageProvider : NSObject <QCPlugInOutputImageProvider> {
  IplImage **iplImageReference;
}

- (QCCVIplImageProvider *) initWithIplImageReference: (IplImage **) iplImageReference;

- (NSRect) imageBounds;
- (CGColorSpaceRef) imageColorSpace;
- (NSArray *) supportedBufferPixelFormats;
- (BOOL) renderToBuffer: (void *) baseAddress
        withBytesPerRow: (NSUInteger) rowBytes
            pixelFormat: (NSString *) format
              forBounds: (NSRect) bounds;


@end
