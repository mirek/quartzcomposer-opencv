//
//  QCCVFindChessboardCorners.h
//  OpenCV
//
//  Created by Mirek Rusin on 05/04/2010.
//  Copyright 2010 Inteliv Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "QCCVAbstractInputImageProcessingPlugIn.h"

@interface QCCVFindChessboardCorners : QCCVAbstractInputImageProcessingPlugIn {
  IplImage *inputIplImageIntensity;

}

@end
