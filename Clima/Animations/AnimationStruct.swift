//
//  AnimationClass.swift
//  Clima
//
//  Created by Naman Jain on 24/06/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//
import UIKit

struct AnimationStruct {
    enum directions{
        case clockwise
        case anticlockwise
        case left
        case right
        case top
        case bottom
    }
    func applyRotationEffect(on myView: UIView, by angle: CGFloat){
        let radians = (angle * CGFloat.pi) / 100
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn,animations: {
            myView.transform = CGAffineTransform(rotationAngle: radians)
        })
    }
}
