//
//  CVIplImageProvider.m
//  VisualObjectTracker
//
//  Created by Mirek Rusin on 19/02/2010.
//  Copyright 2010 Inteliv Ltd. All rights reserved.
//

#import "QCCVIplImageProvider.h"

@implementation QCCVIplImageProvider

- (QCCVIplImageProvider *) initWithIplImageReference: (IplImage **) iplImageReference_ {
  if (self = [super init]) {
    iplImageReference = iplImageReference_; // TODO: retain it?
  }
  return self;
}

- (NSRect) imageBounds {
  return NSMakeRect(0, 0, (*iplImageReference)->width, (*iplImageReference)->height);
}

- (CGColorSpaceRef) imageColorSpace {
  return ((*iplImageReference)->nChannels == 1 ? CGColorSpaceCreateWithName(kCGColorSpaceGenericGray) : CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB));
}

// TODO: return proper stuff
- (NSArray *) supportedBufferPixelFormats {
  return [NSArray arrayWithObjects:
          QCPlugInPixelFormatARGB8,
          QCPlugInPixelFormatBGRA8,
          QCPlugInPixelFormatRGBAf,
          QCPlugInPixelFormatI8,
          QCPlugInPixelFormatIf,
          nil];
}

- (BOOL) renderToBuffer: (void *) baseAddress
        withBytesPerRow: (NSUInteger) rowBytes
            pixelFormat: (NSString *) format
              forBounds: (NSRect) bounds
{
  if (NSEqualRects([self imageBounds], bounds)) {
    memcpy(baseAddress, (*iplImageReference)->imageData, rowBytes * bounds.size.height);
  } else {
    NSLog(@" * image bounds are different");
  }
  return YES;
}

- (void) dealloc {
  // TODO: _iplImage release?
  [super dealloc];
}

@end
