//
//  TimerBarView.swift
//  DrawBerry
//
//  Created by See Zi Yang on 17/4/20.
//  Copyright © 2020 DrawBerry. All rights reserved.
//

import UIKit

class TimerBarView: UIProgressView {
    let duration: TimeInterval
    let completionHandler: (() -> Void)?
    var timer: Timer?

    init(frame: CGRect, duration: TimeInterval, completionHandler: (() -> Void)? = nil) {
        self.duration = duration
        self.completionHandler = completionHandler
        super.init(frame: frame)
        self.progress = 1
        self.progressViewStyle = .bar
        self.transform = self.transform.scaledBy(x: 1, y: 7) // increase bar height
        self.progressTintColor = .systemYellow
    }

    required init?(coder: NSCoder) {
        self.duration = 0
        self.completionHandler = nil
        super.init(coder: coder)
    }

    func start() {
        let progressFraction: Float = 0.01 / Float(duration)

        timer = Timer.scheduledTimer(
            withTimeInterval: 0.01,
            repeats: true,
            block: { timer in
                self.setProgress(self.progress - progressFraction, animated: true)

                if self.progress <= 0.0 {
                    timer.invalidate()
                    self.completionHandler?()
                }
            }
        )
    }

    func stop() {
        timer?.invalidate()
    }
}
