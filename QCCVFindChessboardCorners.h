
#import <Cocoa/Cocoa.h>
#import "QCCVAbstractInputImageProcessingPlugIn.h"

@interface QCCVFindChessboardCorners : QCCVAbstractInputImageProcessingPlugIn {
  NSUInteger innerCornersPerRow;
  NSUInteger innerCornersPerColumn;
  
  BOOL useAdaptiveThreshold;
  BOOL useImageNormalization;
  BOOL useQuadFiltering;
  
  BOOL useImageOutput;
  BOOL useStructureOutput;
}

@property (assign) NSUInteger innerCornersPerRow;
@property (assign) NSUInteger innerCornersPerColumn;

@property (assign) BOOL useAdaptiveThreshold;
@property (assign) BOOL useImageNormalization;
@property (assign) BOOL useQuadFiltering;

@property (assign) BOOL useImageOutput;
@property (assign) BOOL useStructureOutput;

@end
