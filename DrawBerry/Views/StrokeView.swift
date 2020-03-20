//
//  StrokeView.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 20/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//
import UIKit

class StrokeView: UIImageView {
    let stroke: Stroke

    init(frame: CGRect, stroke: Stroke) {
        self.stroke = stroke
        super.init(frame: frame)
    }

    override private init(frame: CGRect) {
        stroke = Stroke.thin
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        nil
    }
}
