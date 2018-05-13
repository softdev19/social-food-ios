//
//  GPUImageFourInputFilter.h
//  SwiftImageFilter
//
//  Created by on 15/11/26.
//  Copyright © 2016年 icetime17. All rights reserved.
//

#import "GPUImage.h"

extern NSString *const kGPUImageFourInputTextureVertexShaderString;

@interface GPUImageFourInputFilter : GPUImageThreeInputFilter
{
    GPUImageFramebuffer *fourthInputFramebuffer;
    
    GLint filterFourthTextureCoordinateAttribute;
    GLint filterInputTextureUniform4;
    GPUImageRotationMode inputRotation4;
    GLuint filterSourceTexture4;
    CMTime fourthFrameTime;
    
    BOOL hasSetThirdTexture, hasReceivedFourthFrame, fourthFrameWasVideo;
    BOOL fourthFrameCheckDisabled;
}

- (void)disableFourthFrameCheck;

@end
