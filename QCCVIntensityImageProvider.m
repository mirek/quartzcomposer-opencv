//
//  QCCVIntensityImageProvider.m
//  VisualObjectTracker
//
//  Created by Mirek Rusin on 20/02/2010.
//  Copyright 2010 Inteliv Ltd. All rights reserved.
//

#import "QCCVIntensityImageProvider.h"

@implementation QCCVIntensityImageProvider

// pixelFormat: (NSString *) pixelFormat
- (id) initWithImageSource: (id<QCPlugInInputImageSource>) image {
  if (self = [super init]) {
    _pixelFormat = QCPlugInPixelFormatIf;
    [self updateIfNecessaryWithInputImageSource: image];
    //      if (pixelFormat != nil && ([pixelFormat isEqualToString: QCPlugInPixelFormatI8] || [pixelFormat isEqualToString: QCPlugInPixelFormatIf])) {
    //        _pixelFormat = pixelFormat;
    //      } else {
    //      }
  }
  return self;
}

- (void) dealloc {
  [(id)_image release];
  [_pixelFormat release];
  [super dealloc];
}

- (void) updateIfNecessaryWithInputImageSource: (id<QCPlugInInputImageSource>) image {
  if (image) {
    if (_image == nil || !NSEqualRects([image imageBounds], [_image imageBounds])) {
      if (_image)
        [(id)_image release];
      _image = [(id)image retain];
    }
  }
  if (_image) {
    ///
  }
}

- (NSRect) imageBounds {
  return [_image imageBounds];
}

- (CGColorSpaceRef) imageColorSpace {
  return CGColorSpaceCreateWithName(kCGColorSpaceGenericGray);
}

- (NSArray *) supportedBufferPixelFormats {
  return [NSArray arrayWithObjects: _pixelFormat, nil];
}

- (BOOL) renderToBuffer: (void *) baseAddress
        withBytesPerRow: (NSUInteger) rowBytes
            pixelFormat: (NSString *) format
              forBounds: (NSRect) bounds
{
  if (![_image lockBufferRepresentationWithPixelFormat: format
                                            colorSpace: [_image imageColorSpace]
                                             forBounds: bounds])
    return NO;
  //if (_pixelFormat == QCPlugInPixelFormatI8) {
  //unsigned long *s = (unsigned long *)[_image bufferBaseAddress];
    unsigned char *d = baseAddress;
    unsigned long sn = [_image bufferPixelsWide] * [_image bufferPixelsHigh];
    unsigned long dn = bounds.size.width * bounds.size.height;
    if (sn == dn) {
      for (unsigned int i = 0; i < sn; i++){
        //d[i] = (unsigned char)(((s[i] >> 8) & 255) + ((s[i] >> 16) & 255) + ((s[i] >> 24) & 255) + 255) >> 2;
        d[i] = (unsigned char)(rand() * 255);
      }
      NSLog(@"ok");
    } else {
      NSLog(@"sn != dn");
      return NO;
    }
  //}
  [_image unlockBufferRepresentation];
  return YES;
}

@end

