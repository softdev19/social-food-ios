//  FSImageViewer
//
//  Created by Felix Schulze on 8/26/2013.
//  Copyright 2013 Felix Schulze. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import "FSImageTitleView.h"



@implementation FSImageTitleView {

    BOOL hidden;
}



- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"FSImageTitleView" owner:self options:nil];
        _view =  [nibObjects objectAtIndex:0];
        _view.frame = self.bounds;
        _view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        [self addSubview:_view];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor colorWithWhite:1.0f alpha:0.8f] setStroke];
    CGContextMoveToPoint(ctx, 0.0f, 0.0f);
    CGContextAddLineToPoint(ctx, self.frame.size.width, 0.0f);
    CGContextStrokePath(ctx);
}



- (void)updateMetadata:(NSString*)author date:(NSString*) createdDate {
    _textLabel.text = author;
    _dateLabel.text = createdDate;
}

- (void)hideView:(BOOL)value {
    if (hidden == value) {
        return;
    }

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [UIView animateWithDuration:0.3f animations:^{
            self.alpha = value ? 0.0f : 1.0f;
        }];
        hidden = value;
    }
    else {
        if (value) {
            [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.frame = CGRectMake(0.0f, self.superview.frame.size.height, self.frame.size.width, self.frame.size.height);
            } completion:nil];
        }
        else {
            [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.frame = CGRectMake(0.0f, self.superview.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
            } completion:nil];
        }
    }
    hidden = value;
}

- (void)setHidden:(BOOL)aHidden {
    hidden = aHidden;
}

- (BOOL)isHidden {
    return hidden;
}


@end
