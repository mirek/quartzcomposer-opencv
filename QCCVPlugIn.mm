//
//  CVPlugIn.m
//  VisualObjectTracker
//
//  Created by Mirek Rusin on 19/02/2010.
//  Copyright 2010 Inteliv Ltd. All rights reserved.
//

#import "QCCVPlugIn.h"

@implementation QCCVPlugIn

+ (BOOL) isIplImage: (IplImage *) iplImage sameAsInputImageSource: (id<QCPlugInInputImageSource>) image {
  if (iplImage != NULL && image != nil) {
    if (iplImage->width == (int)[image imageBounds].size.width && iplImage->height == (int)[image imageBounds].size.height) {
      NSString *pixelFormat = [image bufferPixelFormat];
      if (pixelFormat == QCPlugInPixelFormatARGB8) {
        return iplImage->depth == IPL_DEPTH_8U && iplImage->nChannels == 4;
      } else if (pixelFormat == QCPlugInPixelFormatBGRA8) {
        return iplImage->depth == IPL_DEPTH_8U && iplImage->nChannels == 4;
      } else if (pixelFormat == QCPlugInPixelFormatRGBAf) {
        return iplImage->depth == IPL_DEPTH_32F && iplImage->nChannels == 4;
      } else if (pixelFormat == QCPlugInPixelFormatI8) {
        return iplImage->depth == IPL_DEPTH_8U && iplImage->nChannels == 1;
      } else if (pixelFormat == QCPlugInPixelFormatIf) {
        return iplImage->depth == IPL_DEPTH_32F && iplImage->nChannels == 1;
      } else {
        // Unknown pixelFormat
        return NO;
      }
    } else {
      // Dimentions do not match
      return NO;
    }
  } else {
    // One of images is not allocated
    return NO;
  }
}

+ (IplImage *) cloneIplImageWithInputImageSource: (id<QCPlugInInputImageSource>) image {
  if (image != nil) {
    IplImage *iplImageHeader = [QCCVPlugIn createIplImageHeaderWithInputImageSource: image];
    IplImage *iplImageClone = cvCloneImage(iplImageHeader);
    cvReleaseImageHeader(&iplImageHeader);
    return iplImageClone;
  } else {
    return NULL;
  }
}

+ (IplImage *) createIplImageHeaderWithInputImageSource: (id<QCPlugInInputImageSource>) image {
  IplImage *r = NULL;
  if (image != nil) {
    CvSize size = cvSize([image imageBounds].size.width, [image imageBounds].size.height);
    const char *colorModel;
    const char *channelSeq;
    int depth;
    int channels;
    // The supported formats are:
    // * ARGB8 (8-bit alpha, red, green, blue)
    // * BGRA8 (8-bit blue, green, red, and alpha)
    // * RGBAf (floating-point, red, green, blue, alpha)
    // * I8    (8-bit intensity), and
    // * If    (floating-point intensity).
    if ([image bufferPixelFormat] == QCPlugInPixelFormatARGB8) {
      depth = IPL_DEPTH_8U;
      channels = 4;
      colorModel = (char *)"RGBA";
      channelSeq = (char *)"ARGB";
    } else if ([image bufferPixelFormat] == QCPlugInPixelFormatBGRA8) {
      depth = IPL_DEPTH_8U;
      channels = 4;
      colorModel = (char *)"RGBA";
      channelSeq = (char *)"BGRA";
    } else if ([image bufferPixelFormat] == QCPlugInPixelFormatRGBAf) {
      depth = IPL_DEPTH_32F;
      channels = 4;
      colorModel = (char *)"RGBA";
      channelSeq = (char *)"RGBA";
    } else if ([image bufferPixelFormat] == QCPlugInPixelFormatI8) {
      depth = IPL_DEPTH_8U;
      channels = 1;
      colorModel = (char *)"GREY";
      channelSeq = (char *)"GREY";
    } else if ([image bufferPixelFormat] == QCPlugInPixelFormatIf) {
      depth = IPL_DEPTH_32F;
      channels = 1;
      colorModel = (char *)"GREY";
      channelSeq = (char *)"GREY";
    } else {
      NSLog(@"* Unsupported image type %@", [image bufferPixelFormat]);
      assert(false);
    }
    r = cvCreateImageHeader(size, depth, channels);
    r->imageData = (char *)[image bufferBaseAddress];
    strcpy(r->colorModel, colorModel);
    strcpy(r->channelSeq, channelSeq);
  }
  return r;
}

@end
