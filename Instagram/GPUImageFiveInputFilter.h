//
//  GPUImageFifthInputFilter.h
//  SwiftImageFilter
//
//  Created by on 16/8/6.
//  Copyright © 2016年 icetime17. All rights reserved.
//

#import "GPUImageFourInputFilter.h"

extern NSString *const kGPUImageFiveInputTextureVertexShaderString;

@interface GPUImageFiveInputFilter : GPUImageFourInputFilter
{
    GPUImageFramebuffer *fifthInputFramebuffer;
    
    GLint filterFifthTextureCoordinateAttribute;
    GLint filterInputTextureUniform5;
    GPUImageRotationMode inputRotation5;
    GLuint filterSourceTexture5;
    CMTime fifthFrameTime;
    
    BOOL hasSetFourthTexture, hasReceivedFifthFrame, fifthFrameWasVideo;
    BOOL fifthFrameCheckDisabled;
}

- (void)disableFifthFrameCheck;

@end
