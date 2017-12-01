//
//  Button.swift
//
//  Created by Dmitry Duleba on 1/19/17.
//  Copyright © 2017 Netco Sports. All rights reserved.
//

import UIKit

open class Button: MaterialView {
  
  open let contentView = UIView()
  fileprivate let dimmingView = UIView()
  
  fileprivate var isAnimating = false
  fileprivate var shouldDeselectOnSelection = false
  
  public var action: (() -> Void)?
  public var selectionColor = UIColor.white.withAlphaComponent(0.05) {
    didSet { dimmingView.backgroundColor = selectionColor }
  }
  public var highlightColor = UIColor.white.withAlphaComponent(0.1)
  open var isSelected = false {
    didSet { dimmingView.alpha = isSelected ? 1.0 : 0.0 }
  }
  
  // MARK: - Override
  
  override open var backgroundColor: UIColor? {
    get { return contentView.backgroundColor }
    set { contentView.backgroundColor = newValue }
  }
  
  override open func setup() {
    super.setup()
    addSubviews()
    isShadowVisible = true
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    let bounds = self.bounds
    contentView.frame = bounds
    dimmingView.frame = bounds
  }
  
  // MARK: Touches
  
  override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    let position = self.position(from: touches)
    willSelect()
    select(at: position) { [weak self] in
      guard let selfStrong = self else { return }
      selfStrong.didSelect()
    }
  }
  
  override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    deselect()
  }
  
  override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    deselect()
    
    let position = self.position(from: touches)
    guard bounds.contains(position) else { return }
    
    willCallAction()
    action?()
    didCallAction()
  }
  
  // MARK: - Public
  
  func willSelect() { }
  
  func didSelect() { }
  
  func willCallAction() { }
  
  func didCallAction() { }
}

// MARK: - Private

private extension Button {
  
  // MARK: UI
  
  func addSubviews() {
    addContentView()
    addDimmingView()
  }
  
  func addContentView() {
    contentView.clipsToBounds = true
    addSubview(contentView)
  }
  
  func addDimmingView() {
    dimmingView.backgroundColor = selectionColor
    dimmingView.alpha = 0.0
    dimmingView.isUserInteractionEnabled = false
    contentView.addSubview(dimmingView)
  }
  
  // MARK: Help
  
  func position(from touches: Set<UITouch>) -> CGPoint {
    guard let touch = touches.first else {
      let center = CGPoint(x: bounds.midX, y: bounds.midY)
      return center
    }
    
    let position = touch.location(in: self)
    return position
  }
  
  var outerCicrleRadius: CGFloat {
    let a = bounds.size.width
    let b = bounds.size.height
    let r = sqrt(a * a + b * b)
    return r
  }
  
  // MARK: Logics
  
  func select(at position: CGPoint, animated: Bool = true, completion: (() -> Void)? = nil) {
    dimmingView.superview?.bringSubview(toFront: dimmingView)
    if animated && !isSelected {
      isAnimating = true
      dimmingView.show(animationDuration: 0.3, force: true, completion: { [weak self] in
        guard let selfStrong = self else { return }
        
        selfStrong.isAnimating = false
        if selfStrong.shouldDeselectOnSelection {
          selfStrong.deselect(animated: true)
        }
      })
    }
    
    let circleView = spawnCircleView(at: position)
    let duration = animated ? 1.5 : 0.0
    let side = outerCicrleRadius
    let size = CGSize(width: side, height: side)
    let frame = CGRect(origin: .zero, size: size)
    let center = CGPoint(x: bounds.midX, y: bounds.midY)
    let circleDuration = duration
    let options: UIViewAnimationOptions = [.layoutSubviews]
    UIView.animate(withDuration: circleDuration, delay: 0.0, usingSpringWithDamping: 0.7,
                   initialSpringVelocity: 0.0, options: options, animations: {
                    circleView.bounds = frame
                    circleView.center = center
                    circleView.alpha = 0.0
    }, completion: { _ in
      completion?()
    })
  }
  
  func deselect(animated: Bool = true) {
    guard !isAnimating && !isSelected else {
      shouldDeselectOnSelection = true
      return
    }
    
    shouldDeselectOnSelection = false
    dimmingView.hide(animationDuration: animated ? 0.3 : 0.0)
  }
  
  func spawnCircleView(at location: CGPoint) -> CircleView {
    let circleView = CircleView()
    circleView.translatesAutoresizingMaskIntoConstraints = false
    circleView.backgroundColor = highlightColor
    circleView.isUserInteractionEnabled = false
    circleView.bounds = .zero
    circleView.center = location
    contentView.addSubview(circleView)
    return circleView
  }
}

// MARK: - CircleMaskView

class CircleMaskView: MaterialView {
  
  override func setup() {
    super.setup()
    backgroundColor = .clear
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    let path = UIBezierPath(ovalIn: rect)
    UIColor.white.setFill()
    path.fill()
  }
}

// MARK: - CircleView

class CircleView: MaterialView {
  
  let circleMaskView = CircleMaskView()
  
  override func setup() {
    super.setup()
    mask = circleMaskView
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let size = bounds.size
    circleMaskView.bounds = CGRect(origin: .zero, size: size)
    circleMaskView.center = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
  }
}
