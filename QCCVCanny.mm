//
//  QCCVCanny.m
//  VisualObjectTracker
//
//  Created by Mirek Rusin on 20/02/2010.
//  Copyright 2010 Inteliv Ltd. All rights reserved.
//

#import "QCCVCanny.h"

#if __LP64__
#define QCCV_32_BIT_UINT unsigned short
#else
#define QCCV_32_BIT_UINT unsigned long
#endif

void cvCvtRGBA2GRAY(IplImage *s, IplImage *d) {
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

void cvCvtGRAY2RGBA(IplImage *s, IplImage *d) {
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

@implementation QCCVCanny

@dynamic inputFirstThreshold;
@dynamic inputSecondThreshold;
@dynamic inputApertureSize;

@dynamic inputImage;
@dynamic outputImage;

- (BOOL) ifDifferentUpdateInputIplImageWithInputImage: (id<QCPlugInInputImageSource>) image {
  BOOL didChange = NO;
  if (didChange = [super ifDifferentUpdateInputIplImageWithInputImage: image]) {
    if (inputIplImageIntensity != NULL) {
      cvReleaseImage(&inputIplImageIntensity);
    }
    inputIplImageIntensity = cvCreateImage(cvSize(inputIplImage->width, inputIplImage->height), 8, 1);
  }
  cvCvtRGBA2GRAY(inputIplImage, inputIplImageIntensity);
  //cvCvtColor(inputIplImage, inputIplImageIntensity, CV_RGBA2GRAY);
  return didChange;
}

- (BOOL) ifDifferentUpdateOutputIplImageWithCloneOfInputImage: (id<QCPlugInInputImageSource>) image {
  BOOL didChange = NO;
  if (didChange = [super ifDifferentUpdateOutputIplImageWithCloneOfInputImage: image]) {
    if (outputIplImageIntensity != NULL) {
      cvReleaseImage(&outputIplImageIntensity);
    }
    outputIplImageIntensity = cvCreateImage(cvSize(inputIplImage->width, inputIplImage->height), 8, 1);
  }
  return didChange;
}

@end

@implementation QCCVCanny (ImageProcessingExecution)

- (BOOL) executeImageProcessingWith: (id<QCPlugInContext>) context atTime: (NSTimeInterval) time withArguments: (NSDictionary*) arguments {
  cvCanny(inputIplImageIntensity, outputIplImageIntensity, self.inputFirstThreshold, self.inputSecondThreshold, self.inputApertureSize);
  cvCvtGRAY2RGBA(outputIplImageIntensity, outputIplImage);
  self.outputImage = outputIplImageProvider;
  return YES;
}

@end