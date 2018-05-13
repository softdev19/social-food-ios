//
//  GPUImageSixInputFilter.h
//  SwiftImageFilter
//
//  Created by on 16/8/6.
//  Copyright © 2016年 icetime17. All rights reserved.
//

#import "GPUImageFiveInputFilter.h"

extern NSString *const kGPUImageSixInputTextureVertexShaderString;

@interface GPUImageSixInputFilter : GPUImageFiveInputFilter
{
    GPUImageFramebuffer *sixthInputFramebuffer;
    
    GLint filterSixthTextureCoordinateAttribute;
    GLint filterInputTextureUniform6;
    GPUImageRotationMode inputRotation6;
    GLuint filterSourceTexture6;
    CMTime sixthFrameTime;
    
    BOOL hasSetFifthTexture, hasReceivedSixthFrame, sixthFrameWasVideo;
    BOOL sixthFrameCheckDisabled;
}

- (void)disableSixthFrameCheck;

@end
