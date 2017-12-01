//
//  AnimationCommon.swift
//  FloatingButton
//
//  Created by Dmitry Duleba on 9/26/17.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import Foundation
import UIKit

extension FloatingButton {

  func showDimmingView() {
    guard animation.animationType != .none else {
      dimmingView.alpha = 1.0
      return
    }

    let dimmingAnimationDuration = 0.3
    let dimmingAnimationOptions: UIViewAnimationOptions = [.beginFromCurrentState]
    UIView.animate(withDuration: dimmingAnimationDuration, delay: 0.0, options: dimmingAnimationOptions, animations: {
      self.dimmingView.alpha = 1.0
    })
  }

  func hideDimmingView() {
    guard animation.animationType != .none else {
      dimmingView.alpha = 0.0
      return
    }

    let dimmingAnimationDuration = 0.3
    let dimmingAnimationOptions: UIViewAnimationOptions = [.beginFromCurrentState]
    UIView.animate(withDuration: dimmingAnimationDuration, delay: 0.0, options: dimmingAnimationOptions, animations: {
      self.dimmingView.alpha = 0.0
    })
  }
}
