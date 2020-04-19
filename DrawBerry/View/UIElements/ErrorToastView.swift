//
//  ErrorToastView.swift
//  DrawBerry
//
//  Created by See Zi Yang on 18/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class ErrorToastView: UILabel {
    static var prevError: ErrorToastView?

    init(message: String, showFor duration: Double, frameMaxX: CGFloat, frameMaxY: CGFloat) {
        super.init(frame: CGRect(x: frameMaxX / 2 - 250, y: frameMaxY - 150, width: 500, height: 50))

        ErrorToastView.prevError?.removeFromSuperview()
        ErrorToastView.prevError = self

        self.text = message

        self.backgroundColor = Constants.errorLabelColor
        self.font = .systemFont(ofSize: 24)
        self.textAlignment = .center
        self.textColor = .white

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 2

        DispatchQueue.main.asyncAfter(deadline: .now() + duration,
                                      execute: { [weak self] in self?.removeFromSuperview() })
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
