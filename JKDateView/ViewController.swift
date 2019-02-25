//
//  ViewController.swift
//  JKDateView
//
//  Created by Justin Kaufman on 2/25/19.
//  Copyright © 2019 Justin Kaufman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateLabelTopConstraint: NSLayoutConstraint!

    override var prefersStatusBarHidden: Bool { return true }
    override var prefersHomeIndicatorAutoHidden: Bool { return true }

    private var isShowingDate: Bool = false {
        didSet { isShowingDate ? showDate() : hideDate() }
    }

    @IBAction func didTapTime(_ sender: AnyObject) {
        isShowingDate = !isShowingDate
    }
}

private extension ViewController {
    func showDate() {
        let animator = UIViewPropertyAnimator.springAnimator(
            duration: 0.7,
            animations: { [unowned self] in
                self.dateLabel.alpha = 1.0
                self.dateLabelTopConstraint.constant = 37.5
                self.view.layoutIfNeeded()
            },
            completion: { [unowned self] _ in
                self.hideDate(true)
            }
        )
        animator.start(animated: true)
    }

    func hideDate(_ delay: Bool = false) {
        guard !delay else {
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 2.75,
                execute: { [unowned self] in
                    if self.isShowingDate { self.isShowingDate = false }
                }
            )
            return
        }

        let animator = UIViewPropertyAnimator.springAnimator(
            duration: 0.45,
            animations: { [unowned self] in
                self.dateLabelTopConstraint.constant = 22.0
                self.view.layoutIfNeeded()
                self.dateLabel.alpha = 0.0
            },
            completion: nil
        )
        animator.start(animated: true)
    }
}

extension UIViewPropertyAnimator {
    static func springAnimator(duration: TimeInterval,
                               animations: (() -> Void)?,
                               completion: ((UIViewAnimatingPosition) -> Void)?) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1.0, animations: animations)
        if let completion = completion { animator.addCompletion(completion) }
        return animator
    }

    func start(animated: Bool) {
        startAnimation()
        if !animated {
            stopAnimation(false)
            finishAnimation(at: .end)
        }
    }
}
