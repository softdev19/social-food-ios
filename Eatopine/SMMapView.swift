//
//  SMMapView.swift
//  Eatopine
//
//  Created by Borna Beakovic on 14/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit
import MapKit

class SMMapView: MKMapView,UIGestureRecognizerDelegate {

    var calloutView:SMCalloutView?
    
    /*
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view is UIControl {
            return false
        }else{
          //  return super.gestureRecognizer(gestureRecognizer,touch)
        }
    }
    */
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
      //  println("callout \(calloutView)")
        
        let calloutMaybe = self.calloutView!.hitTest(self.calloutView!.convertPoint(point, fromView: self), withEvent: event)
        if calloutMaybe != nil {
            return calloutMaybe
        }else{
            return super.hitTest(point, withEvent: event)
        }
    }
}
