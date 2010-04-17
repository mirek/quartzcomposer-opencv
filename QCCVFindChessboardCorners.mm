
#import "QCCVFindChessboardCorners.h"

@implementation QCCVFindChessboardCorners

@dynamic inputImage;

@synthesize innerCornersPerRow;
@synthesize innerCornersPerColumn;

@synthesize useAdaptiveThreshold;
@synthesize useImageNormalization;
@synthesize useQuadFiltering;

@synthesize useImageOutput;
@synthesize useStructureOutput;

- (id) init {
  if (self = [super init]) {
    useImageIntensity = YES;
    
    // Some defaults for serialized plugin keys
    innerCornersPerRow = 8;
    innerCornersPerColumn = 6;
    useAdaptiveThreshold = YES;
    useImageNormalization = YES;
    useQuadFiltering = YES;
    
    // Those two guys are tricky, let's set them like this...
    useImageOutput = NO;
    useStructureOutput = NO;

    // ...now let's listen to property changes so we can add/remove output image and structure ports dynamically
    [self addObserver: self forKeyPath: @"useImageOutput" options: NSKeyValueObservingOptionNew context: NULL];
    [self addObserver: self forKeyPath: @"useStructureOutput" options: NSKeyValueObservingOptionNew context: NULL];

    // ...and finally set them to true so they trigger creating ports as default
    self.useImageOutput = YES;
    self.useStructureOutput = YES;
  
  }
  return self;
}

//- (BOOL) validateInnerCornersPerRow: (id *) value error: (NSError **) error {
//  if (*value == nil) {
//    return YES;
//  }
//  if ([*value integerValue] >= 1 && [*value integerValue] <= 32) {
//    return YES;
//  } else {
//    *error = [[[NSError alloc] initWithDomain: @"Domain"
//                                         code: 1
//                                     userInfo: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                @"Please use value between 1 and 32", NSLocalizedDescriptionKey,
//                                                @"Please provide valid number of inner corners per row", NSLocalizedRecoverySuggestionErrorKey,
//                                                nil]] autorelease];
//    return NO;
//  }
//}

- (void) observeValueForKeyPath: (NSString *) keyPath ofObject: (id) object change: (NSDictionary *) change context: (void *) context {
  if ([keyPath isEqualToString: @"useImageOutput"]) {
    if (useImageOutput)
      [self addOutputPortWithType: QCPortTypeImage forKey: @"outputImage" withAttributes: [[self class] attributesForPropertyPortWithKey: @"outputImage"]];
    else
      [self removeOutputPortForKey: @"outputImage"];
    
  } else if ([keyPath isEqualToString: @"useStructureOutput"]) {
      if (useStructureOutput)
        [self addOutputPortWithType: QCPortTypeStructure forKey: @"outputStructure" withAttributes: [[self class] attributesForPropertyPortWithKey: @"outputStructure"]];
      else
        [self removeOutputPortForKey: @"outputStructure"];
  }
}

// We want to remember (serialize) those attributes in qtz file
+ (NSArray *) plugInKeys {
  return [NSArray arrayWithObjects:
          @"innerCornersPerRow",
          @"innerCornersPerColumn",
          @"useImageNormalization",
          @"useAdaptiveThreshold",
          @"useQuadFiltering",
          @"useImageOutput",
          @"useStructureOutput",
          nil];
}

@end

@implementation QCCVFindChessboardCorners (ImageProcessingExecution)

- (BOOL) executeImageProcessingWith: (id<QCPlugInContext>) context atTime: (NSTimeInterval) time withArguments: (NSDictionary *) arguments {
  CvSize boardSize = cvSize(innerCornersPerRow, innerCornersPerColumn);
  CvPoint2D32f *corners = (CvPoint2D32f *)calloc(sizeof(CvPoint2D32f), boardSize.width * boardSize.height);
  int cornerCount = 0;
  int found = cvFindChessboardCorners(inputIplImageIntensity,
                                      boardSize,
                                      corners,
                                      &cornerCount,
                                      (CV_CALIB_CB_NORMALIZE_IMAGE & useImageNormalization) |
                                      (CV_CALIB_CB_ADAPTIVE_THRESH & useAdaptiveThreshold) |
                                      (CV_CALIB_CB_FILTER_QUADS & useQuadFiltering));

  // Update output image if enabled
  if (useImageOutput) {
    memset(outputIplImage->imageData, 255, outputIplImage->width * outputIplImage->height * outputIplImage->nChannels);
    cvDrawChessboardCorners(outputIplImage,
                            boardSize,
                            corners,
                            cornerCount,
                            found);
    int sn = outputIplImage->width * outputIplImage->height * outputIplImage->nChannels;
    unsigned char *s = (unsigned char *)(outputIplImage->imageData);
    for (int i = 0; i < sn; i += 4)
      s[i + 3] = 255 - s[i + 3];
    
    [self setValue: outputIplImageProvider forOutputKey: @"outputImage"];
  }
  
  // Update output structure if enabled
  if (useStructureOutput) {
    NSMutableDictionary *outputStructure = [NSMutableDictionary dictionaryWithCapacity: cornerCount];
    for (int i; i < cornerCount; i++) {
      [outputStructure setValue: [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithFloat: corners[i].x], @"x",
                                  [NSNumber numberWithFloat: corners[i].y], @"y",
                                  nil]
                         forKey: [NSString stringWithFormat: @"%i", i]];
    }
    [self setValue: outputStructure forOutputKey: @"outputStructure"];
  }
  
  free(corners);
  
  return YES;
}

@end
