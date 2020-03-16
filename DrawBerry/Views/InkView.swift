//
//  InkView.swift
//  DrawBerry
//
//  Created by Hol Yin Ho on 15/3/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class InkView: UIImageView {
    let color: UIColor

    init(frame: CGRect, color: UIColor) {
        self.color = color
        super.init(frame: frame)
    }

    private override init(frame: CGRect) {
        color = UIColor.black
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        return nil
    }
}
