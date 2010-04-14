
#import <Quartz/Quartz.h>
//#import <OpenCV/OpenCV.h>
#import <opencv/cv.h>

@interface QCCVPlugIn : QCPlugIn {
}

+ (NSUInteger) apertureSizeValueWithIndex: (NSUInteger) index;

+ (NSString *) detailsWithIplImage: (IplImage *) iplImage;

+ (BOOL) isIplImage: (IplImage *) iplImage sameSizeAndFormatAsInputImageSource: (id<QCPlugInInputImageSource>) image;
+ (IplImage *) createIplImageHeaderWithInputImageSource: (id<QCPlugInInputImageSource>) image;
+ (IplImage *) cloneIplImageWithInputImageSource: (id<QCPlugInInputImageSource>) image;
+ (void) convertRGBA: (IplImage *) s toGRAY: (IplImage *) d;
+ (void) convertGRAY: (IplImage *) s toRGBA: (IplImage *) d;

+ (NSMutableDictionary *) plugInInfos;
+ (NSMutableDictionary *) plugInInfoWithClass: (Class) aClass;
+ (void) setPlugInInfo: (NSDictionary *) plugInInfo forClass: (Class) aClass;

+ (NSDictionary *) plugInInfo;
+ (NSDictionary *) attributes;
+ (NSDictionary *) attributesForPropertyPortWithKey: (NSString *) key;

@end
