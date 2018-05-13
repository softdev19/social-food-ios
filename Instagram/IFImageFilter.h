//
//  InstagramFilter.h
//  GPUImageFilters
//

#import "GPUImage.h"

#import "GPUImageSixInputFilter.h"


@interface IFImageFilter : GPUImageFilterGroup

+(NSArray<Class>*)allFilterClasses;
+(GPUImagePicture*)filterImageNamed:(NSString*)name;


- (id)initWithFragmentShaderFromString:(NSString *)fragmentShaderString sources:(NSArray<GPUImagePicture*>*)sources;
- (id)initWithFragmentShaderFromString:(NSString *)fragmentShaderString;

- (NSString*)name;

@end

