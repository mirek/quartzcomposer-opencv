//
//  CVPlugIn.h
//  VisualObjectTracker
//
//  Created by Mirek Rusin on 19/02/2010.
//  Copyright 2010 Inteliv Ltd. All rights reserved.
//

#import <Quartz/Quartz.h>
//#import <OpenCV/OpenCV.h>
#import <opencv/cv.h>

@interface QCCVPlugIn : QCPlugIn {

}

+ (BOOL) isIplImage: (IplImage *) iplImage sameAsInputImageSource: (id<QCPlugInInputImageSource>) image;
+ (IplImage *) createIplImageHeaderWithInputImageSource: (id<QCPlugInInputImageSource>) image;
+ (IplImage *) cloneIplImageWithInputImageSource: (id<QCPlugInInputImageSource>) image;

@end
