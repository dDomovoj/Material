//
//  ContentView.swift
//
//  Created by Dmitry Duleba on 5/15/17.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import Foundation
import UIKit

class ContentView: UIView {
  
  var interactiveViews: [UIView] = []
  var passHandler: (() -> Void)?
  var shouldCancelTouch = true
  
  required public init() {
    let frame = UIScreen.main.bounds
    super.init(frame: frame)
    backgroundColor = .clear
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let pass = { [weak self] () -> UIView? in
      self?.passHandler?()
      let cancelTouch = self?.shouldCancelTouch ?? false
      return cancelTouch ? self : nil
    }
    
    for view in interactiveViews {
      var shouldHitTest = false
      if view is ContentView {
        shouldHitTest = true
      }
      
      let localFrame = view.convert(view.bounds, to: self)
      if localFrame.contains(point) {
        shouldHitTest = true
      }
      
      if shouldHitTest {
        let localPoint = view.convert(point, from: self)
        let result = view.hitTest(localPoint, with: event)
        if result != nil {
          return result
        }
      }
    }
    return pass()
  }
}
