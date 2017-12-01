//
//  BaseView.swift
//
//  Created by Dmitry Duleba on 1/19/17.
//  Copyright © 2017 Netco Sports. All rights reserved.
//

import UIKit

open class MaterialView: UIView {

  open var isShadowVisible = false {
    didSet {
      if isShadowVisible {
        addShadow(to: self)
      } else {
        removeShadow(from: self)
      }
    }
  }

  // MARK: - Init

  convenience public init() {
    self.init(frame: .zero)
  }

  override public init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  override open func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public

  open func setup() { }
}

// MARK: - Private

private extension MaterialView {

  func addShadow(to view: UIView) {
    view.layer.shadowRadius = CGFloat(1.5)
    view.layer.shadowOpacity = 0.3
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = .zero
    view.layer.cornerRadius = 1.0
  }

  func removeShadow(from view: UIView) {
    view.layer.shadowOpacity = 0.0
  }
}
