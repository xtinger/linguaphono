//
//  RoundedProgressView.swift
//  Flashcards
//
//  Created by Denis Voronov on 21/05/2018.
//  Copyright © 2018 Emanor. All rights reserved.
//

import UIKit

class RoundedProgressView : UIProgressView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maskLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: frame.height / 2.0)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskLayerPath.cgPath
        layer.mask = maskLayer
    }
}
