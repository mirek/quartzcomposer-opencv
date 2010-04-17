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
  CGColorSpaceRef colorSpace = nil;
  switch ((*iplImageReference)->nChannels) {
    case 1: colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericGray); break;
    case 4: colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB); break;\
  }
  NSLog(@"* Color space %@", colorSpace);
  return colorSpace;
}

// TODO: cache
- (NSArray *) supportedBufferPixelFormats {
  switch ((*iplImageReference)->nChannels) {
    case 1:
      switch ((*iplImageReference)->depth) {
        case IPL_DEPTH_32F: return [NSArray arrayWithObjects: QCPlugInPixelFormatIf, nil];
        case IPL_DEPTH_8U:  return [NSArray arrayWithObjects: QCPlugInPixelFormatI8, nil];
        default: return nil;
      }
    
    case 4:
      switch ((*iplImageReference)->depth) {
        case IPL_DEPTH_32F: return [NSArray arrayWithObjects: QCPlugInPixelFormatRGBAf, nil];
        case IPL_DEPTH_8U:  return [NSArray arrayWithObjects: QCPlugInPixelFormatBGRA8, nil];
        default: return nil;
      }
      
    default: return nil;
  }
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
