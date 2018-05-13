//  FSImageViewer
//
//  Created by Felix Schulze on 9/04/2013.
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

#import "FSBasicImage.h"

@implementation FSBasicImage

@synthesize URL = _URL;
@synthesize title = _title;
@synthesize size = _size;
@synthesize image = _image;
@synthesize failed = _failed;
@synthesize createdDateString = _createdDateString;

- (instancetype)initWithImageURL:(NSURL *)aURL name:(NSString *)aName image:(UIImage *)aImage {
    self = [super init];
    if (self) {
        _URL = aURL;
        _title = aName;
        self.image = aImage;
        
    }
    return self;
}

- (instancetype _Nonnull)initWithImageURL:(NSURL * _Nonnull)aURL authorName:(NSString * _Nullable)aAuthorName dateCreatedString:(NSString * _Nullable) aDateCreatedString{
    self = [super init];
    if (self) {
        _URL = aURL;
        _title = aAuthorName;
        _createdDateString = aDateCreatedString;
        self.image = nil;
        
    }
    return self;
}

- (instancetype)initWithImageURL:(NSURL *)aURL name:(NSString *)aName {
    return [self initWithImageURL:aURL name:aName image:nil];
}

- (instancetype)initWithImageURL:(NSURL *)aURL {
    return [self initWithImageURL:aURL name:nil image:nil];
}

- (instancetype)initWithImage:(UIImage *)aImage {
    return [self initWithImageURL:nil name:nil image:aImage];
}

- (instancetype)initWithImage:(UIImage *)aImage name:(NSString *)aName {
    return [self initWithImageURL:nil name:aName image:aImage];
}

@end
