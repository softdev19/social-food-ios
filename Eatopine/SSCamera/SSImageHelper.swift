//
//  SSImageHelper.swift
//  SSCamera
//
//  Created by ShawnDu on 15/12/15.
//  Copyright © 2015年 Shawn. All rights reserved.
//

import UIKit

let kLimitSize: CGFloat = 1280

struct SSImageHelper {
    
    static func scaleImage(_ inputImage: UIImage, isFrontCamera: Bool) -> UIImage {
        var width = inputImage.width
        var height = inputImage.height
        var outputImage = inputImage
        let maxValue = max(width, height)
        if isFrontCamera {
            outputImage = UIImage(cgImage: inputImage.cgImage!, scale: inputImage.scale, orientation: UIImageOrientation.leftMirrored)
        }
        if maxValue > kLimitSize {
            if  height >= width {
                height = kLimitSize
                width = inputImage.width / inputImage.height * kLimitSize
            } else {
                width = kLimitSize
                height = inputImage.height / inputImage.width * kLimitSize
            }
        }
        outputImage = SSImageHelper.scaleToSize(outputImage, size: CGSize(width: width, height: height))
        
        return outputImage
    }
    
    static func scaleToSize(_ inputImage: UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        inputImage.draw(in: CGRect(x: 0,y: 0, width: size.width, height: size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
    
    static func clipImage(_ inputImage: UIImage, toRect: CGRect) -> UIImage {
        let cgImageRef = inputImage.cgImage
        let subImageRef = cgImageRef?.cropping(to: toRect)
        let smallBounds = CGRect(x: 0, y: 0, width: CGFloat((subImageRef?.width)!), height: CGFloat((subImageRef?.height)!))
        UIGraphicsBeginImageContext(smallBounds.size)
        let context = UIGraphicsGetCurrentContext()
        context?.draw(subImageRef!, in: smallBounds)
        let smallImage = UIImage(cgImage: subImageRef!)
        UIGraphicsEndImageContext()
        return smallImage
    }
}
