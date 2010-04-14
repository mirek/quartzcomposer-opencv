
#import "QCCVPlugIn.h"

#if __LP64__
#define QCCV_32_BIT_UINT unsigned short
#else
#define QCCV_32_BIT_UINT unsigned long
#endif

// Do not access this variable directly, use [QXCPlugIn plugInInfos] from your derived class instead.
// { classNameA : { ... }, classNameB: { ... } } dictionary to cache xml attributes for multiple classes
// ...one day Objective-C will support class attributes with inheritance and we won't have to do it.
static NSMutableDictionary *QCCVPlugIn_plugInInfos;

@implementation QCCVPlugIn

// IplImage details as string
+ (NSString *) detailsWithIplImage: (IplImage *) iplImage {
  if (iplImage) {
    return [NSString stringWithFormat: @"<IplImage width=%i height=%i channels=%i depth=%i>",
            iplImage->width,
            iplImage->height,
            iplImage->nChannels,
            iplImage->depth];
  } else {
    return @"<IplImage NULL>";
  }
}

// Size of the extended Sobel kernel, must be 1, 3, 5 or 7
// Use this function to convert from menu item index 0, 1, 2, 3 -> 1, 3, 5, 7
+ (NSUInteger) apertureSizeValueWithIndex: (NSUInteger) index {
  switch (index) {
    case 0: return 3; break;
    case 1: return 5; break;
    case 2: return 7; break;
    default: return 3;
  }
}

+ (void) convertRGBA: (IplImage *) s toGRAY: (IplImage *) d {
  int sn = s->widthStep * s->height;
  int dn = d->widthStep * d->height;
  //  int n = d->width * d->height;
  //  QCCV_32_BIT_UINT *s2 = (QCCV_32_BIT_UINT *)s->imageData;
  unsigned char *s2 = (unsigned char *)s->imageData;
  unsigned char *d2 = (unsigned char *)d->imageData;
  for (int i = 0, j = 0; i < sn && j < dn; i += 4, j++) {
    d2[j] = (s2[i] + s2[i + 1] + s2[i + 3] + 255) >> 2; //(((s2[i] >> 8) & 255) + ((s2[i] >> 16) & 255) + ((s2[i] >> 24) & 255) + 255) >> 2;
  }
}

+ (void) convertGRAY: (IplImage *) s toRGBA: (IplImage *) d {
  int sn = s->widthStep * s->height;
  int dn = d->widthStep * d->height;
  //  cvCvtColor(s, d, CV_GRAY2RGB);
  //  unsigned char *d2 = (unsigned char *)d->imageData;
  //  for (int i = 0; i < n; i += 4)
  //    d2[i + 3] = 255;
  unsigned char *s2 = (unsigned char *)s->imageData;
  unsigned char *d2 = (unsigned char *)d->imageData;
  //  QCCV_32_BIT_UINT *d2 = (QCCV_32_BIT_UINT *)d->imageData;
  for (int i = 0, j = 0; i < sn && j < dn; i++, j += 4) {
    d2[j + 0] = s2[i];
    d2[j + 1] = s2[i];
    d2[j + 2] = s2[i];
    d2[j + 3] = 255;
    //    d2[i] = rand() * 255; //((QCCV_32_BIT_UINT)s2[i] << 24) & ((QCCV_32_BIT_UINT)s2[i] << 16) & ((QCCV_32_BIT_UINT)s2[i] << 8) & (QCCV_32_BIT_UINT)255;
  }
}

/// Check if IplImage and id<QCPlugInInputImageSource> are of the same size and pixel format
+ (BOOL) isIplImage: (IplImage *) iplImage sameSizeAndFormatAsInputImageSource: (id<QCPlugInInputImageSource>) image {
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
        return NO; // Unknown pixelFormat
      }
    } else {
      return NO; // Dimentions do not match
    }
  } else {
    return NO; // At least one of the images has not been allocated
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

// Quartz Composer supports:
// * ARGB8 (8-bit alpha, red, green, blue)
// * BGRA8 (8-bit blue, green, red, and alpha)
// * RGBAf (floating-point, red, green, blue, alpha)
// * I8    (8-bit intensity), and
// * If    (floating-point intensity).
+ (IplImage *) createIplImageHeaderWithInputImageSource: (id<QCPlugInInputImageSource>) image {
  IplImage *r = NULL;
  if (image != nil) {
    CvSize size = cvSize([image imageBounds].size.width, [image imageBounds].size.height);
    const char *colorModel;
    const char *channelSeq;
    int depth;
    int channels;
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

// Default implementation tries to create controller for $PlugInName$.nib bundle resource
- (QCPlugInViewController *) createViewController {
  NSBundle *bundle = [NSBundle bundleForClass: [self class]];
  NSString *nibName = [NSString stringWithFormat: @"%@", self.className];
  if ([bundle pathForResource: nibName ofType: @"nib"]) {
    return [[QCPlugInViewController alloc] initWithPlugIn: self viewNibName: nibName];
  } else {
    return nil;
  }
}

// TODO: move to +initialize
+ (NSMutableDictionary *) plugInInfos {
  if (QCCVPlugIn_plugInInfos == nil) {
    QCCVPlugIn_plugInInfos = [[NSMutableDictionary alloc] init];
  }
  return QCCVPlugIn_plugInInfos;
}

+ (NSMutableDictionary *) plugInInfoWithClass: (Class) aClass {
  return [self.plugInInfos objectForKey: NSStringFromClass(aClass)];
}

+ (void) setPlugInInfo: (NSMutableDictionary *) plugInInfo forClass: (Class) aClass {
  [self.plugInInfos setObject: plugInInfo forKey: NSStringFromClass(aClass)];
}

+ (NSDictionary *) plugInInfo {
  NSPropertyListFormat format;
  NSString *errorDescription;
  //@synchronized {
  NSDictionary *r = [self plugInInfoWithClass: [self class]];
  if (r == nil) {
    NSString *path = [[NSBundle bundleForClass: [self class]] pathForResource: NSStringFromClass([self class]) ofType: @"plist"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath: path];
    if (data) {
      r = [NSPropertyListSerialization propertyListFromData: data
                                           mutabilityOption: NSPropertyListImmutable
                                                     format: &format
                                           errorDescription: &errorDescription];
      [self setPlugInInfo: r forClass: [self class]];
    }
  }
  //}
  return r;
}

+ (NSDictionary *) attributes {
  if ([self plugInInfo]) {
    return [self plugInInfo];
  } else {
    return [super attributes];
  }
}

+ (NSDictionary *) attributesForPropertyPortWithKey:(NSString *) key {
  return [[[self plugInInfo] objectForKey: @"attributes"] objectForKey: key];
}

@end
