//
//  AnimationSlideUp.swift
//  FloatingButton
//
//  Created by Dmitry Duleba on 9/26/17.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import Foundation
import UIKit

extension FloatingButton {

  func slideUpExpansionAnimation(with animationId: Int) {
    let options: UIViewAnimationOptions = [.allowUserInteraction, .layoutSubviews]
    UIView.animate(withDuration: animation.duration, delay: 0.0, options: options, animations: {
      self.layout()
      self.update()
    }, completion: { _ in
      self.finalizeAnimation(with: animationId)
    })
  }

  func slideUpCollapseAnimation(with animationId: Int) {
    let options: UIViewAnimationOptions = [.allowUserInteraction, .layoutSubviews]
    UIView.animate(withDuration: animation.duration, delay: 0.0, options: options, animations: {
      self.layout()
      self.update()
    }, completion: { _ in
      self.finalizeAnimation(with: animationId)
    })
  }
}
