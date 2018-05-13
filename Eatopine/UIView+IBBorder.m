//
//  UIView+IBBorder.m
//  LAEvent
//
//  Created by Borna Beakovic on 06/07/15.
//  Copyright (c) 2015 LA. All rights reserved.
//

#import "UIView+IBBorder.h"

@implementation UIView (IBBorder)
@dynamic borderColor,borderWidth,cornerRadius;

-(void)setBorderColor:(UIColor *)borderColor{
    [self.layer setBorderColor:borderColor.CGColor];
}

-(void)setBorderWidth:(NSInteger)borderWidth{
    [self.layer setBorderWidth:borderWidth];
}

-(void)setCornerRadius:(NSInteger)cornerRadius{
    [self.layer setCornerRadius:cornerRadius];
}
@end
