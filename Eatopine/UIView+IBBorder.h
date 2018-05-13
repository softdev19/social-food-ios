//
//  UIView+IBBorder.h
//  LAEvent
//
//  Created by Borna Beakovic on 06/07/15.
//  Copyright (c) 2015 LA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IBBorder)
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable NSInteger borderWidth;
@property (nonatomic) IBInspectable NSInteger cornerRadius;
@end
