//
//  CircleButton.swift
//
//  Created by Dmitry Duleba on 1/19/17.
//  Copyright © 2017 Netco Sports. All rights reserved.
//

import UIKit

open class CircleButton: Button {
  
  fileprivate var circleMaskView: UIView!
  
  override open var frame: CGRect {
    get { return super.frame }
    set { super.frame = newValue.innerSqare }
  }
  
  override open var bounds: CGRect {
    get { return super.bounds }
    set { super.bounds = newValue.innerSqare }
  }
  
  override public init(frame: CGRect) {
    super.init(frame: frame.innerSqare)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override open func setup() {
    super.setup()
    circleMaskView = CircleMaskView()
    contentView.mask = circleMaskView
  }
  
  override open func layoutSubviews() {
    super.layoutSubviews()
    let size = bounds.size
    circleMaskView.bounds = CGRect(origin: .zero, size: size)
    circleMaskView.center = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
  }
}

// MARK: - Private

fileprivate extension CGRect {
  
  var innerSqare: CGRect {
    guard width != height else { return self }
    
    let side = min(width, height)
    let size = CGSize(width: side, height: side)
    let origin = CGPoint(x: midX - size.width * 0.5, y: midY - size.height * 0.5)
    let rect = CGRect(origin: origin, size: size)
    return rect
  }
}
