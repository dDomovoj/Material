//
//  FloatingButton.swift
//  FloatingButton
//
//  Created by Dmitry Duleba on 9/26/17.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import UIKit

// swiftlint:disable file_length

open class FloatingButton: MaterialView {

  public var actions: [Action] { didSet { reloadData() } }
  public var itemSpacing: CGFloat = 12.0 { didSet { reloadData() } }
  public var animation = Animation()
  public var position = Position.bottomRight
  public var coverColor = UIColor.black.withAlphaComponent(0.75) { didSet { dimmingView.backgroundColor = coverColor } }
  public var shouldTintIcons = false { didSet { reloadData(force: true) } }
  public var shouldCancelTouch = true {
    didSet {
      contentView.shouldCancelTouch = shouldCancelTouch
      itemsContentView.shouldCancelTouch = shouldCancelTouch
    }
  }

  public fileprivate(set) var state = State.collapsed {
    willSet { willChangeStateHandler?(newValue) }
  }
  public var willChangeStateHandler: ((State) -> Void)?

  // MARK: UI

  var showWindow: UIView?
  let contentView = FloatingButton.ContentView()
  let dimmingView = UIView()
  let itemsContentView = FloatingButton.ContentView()
  var buttons = [ItemButton]()
  var descriptionLabels = [UILabel]()

  // MARK: Private

  var freshLayout = false
  var runningAnimationId: Int? {
    didSet {
      runningAnimationTimestamp = Date.timeIntervalSinceReferenceDate
    }
  }
  var runningAnimationTimestamp: TimeInterval = 0.0 {
    didSet {
      previousAnimationTimestampDelta = runningAnimationTimestamp - oldValue
    }
  }
  var previousAnimationTimestampDelta: TimeInterval?

  // MARK: - Init

  required public init(actions: [Action]) {
    self.actions = actions
    super.init(frame: .zero)
    setup()
  }

  convenience public required init() {
    self.init(actions: [])
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Override

  open override func didMoveToSuperview() {
    super.didMoveToSuperview()
    guard superview != nil else { return }

    freshLayout = true
  }

  open override func setup() {
    super.setup()
    clipsToBounds = false
    translatesAutoresizingMaskIntoConstraints = false
    addSubviews()
    reloadData()
  }

  open override func layoutSubviews() {
    super.layoutSubviews()
    guard freshLayout else { return }

    freshLayout = false
    moveContentFromWindow(force: true)
    layout()
    update()
  }

  // MARK: - Open

  open func expand() {
    guard state == .collapsed || state == .collapsing else { return }

    toggleState()
  }

  open func collapse() {
    guard state == .expanded || state == .expanding else { return }

    toggleState()
  }

  open func toggle() {
    toggleState()
  }
}

// MARK: - UI

fileprivate extension FloatingButton {

  func addSubviews() {
    addContentView()
    addDimmingView()
    addItemsContentView()
  }

  func addContentView() {
    addSubview(contentView)
    contentView.interactiveViews = [itemsContentView]
    contentView.passHandler = { [weak self] in
      self?.collapse()
    }
  }

  func addDimmingView() {
    dimmingView.backgroundColor = coverColor
    dimmingView.alpha = 0.0
    contentView.addSubview(dimmingView)
  }

  func addItemsContentView() {
    itemsContentView.clipsToBounds = false
    itemsContentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(itemsContentView)
    itemsContentView.passHandler = { [weak self] in
      self?.collapse()
    }
  }
}

extension FloatingButton {

  func toggleState() {
    let currentState = state
    switch state {
    case .expanded, .expanding: state = .collapsing
    case .collapsed: state = .expanding
    case .collapsing: break
    }
    guard state != currentState else { return }

    prepareAnimation()
    animateIfNeeded()
  }

  func prepareAnimation() {
    if state == .expanding {
      moveContentToWindow()
    }
  }

  func animateIfNeeded() {
    if state == .collapsing {
      animateCollapse()
    } else if state == .expanding {
      animateExpansion()
    }
  }

  func animateExpansion() {
    let animationId = Int.random()
    runningAnimationId = animationId
    showDimmingView()
    switch animation.animationType {
    case .none:
      layout()
      update()
      finalizeAnimation(with: animationId)
    case .slideUp: slideUpExpansionAnimation(with: animationId)
    case .bubble: bubbleExpansionAnimation(with: animationId)
    }
  }

  func animateCollapse() {
    let animationId = Int.random()
    runningAnimationId = animationId
    hideDimmingView()
    switch animation.animationType {
    case .none:
      layout()
      update()
      finalizeAnimation(with: animationId)
    case .slideUp: slideUpCollapseAnimation(with: animationId)
    case .bubble: bubbleCollapseAnimation(with: animationId)
    }
  }

  func finalizeAnimation(with id: Int) {
    guard runningAnimationId == id else { return }

    if state == .expanding {
      state = .expanded
    } else if state == .collapsing {
      state = .collapsed
      moveContentFromWindow()
    }
  }

  // MARK: - Window translation

  func moveContentToWindow() {
    guard showWindow == nil else { return }

    showWindow = window ?? superview
    showWindow?.addSubview(contentView)
    layoutContentViewToWindow()
  }

  func moveContentFromWindow(force: Bool = false) {
    if !force {
      guard showWindow != nil else { return }
    }

    showWindow = nil
    addSubview(contentView)
    layoutContentViewFromWindow()
  }

  func layoutContentViewFromWindow() {
    guard let superview = superview else { return }

    contentView.frame = convert(superview.bounds, from: superview)
    dimmingView.frame = contentView.bounds
    itemsContentView.frame = frame
  }

  func layoutContentViewToWindow() {
    guard let window = showWindow else { return }

    contentView.frame = window.bounds
    dimmingView.frame = contentView.bounds
    itemsContentView.frame = convert(bounds, to: window)
  }

  // MARK: - Reload

  func reloadActions() {
    zip(buttons, actions).enumerated().forEach { index, item in
      item.0.actionItem = item.1
      item.0.action = { [weak self] in
        self?.handle(action: item.1, at: index)
      }
    }
    zip(descriptionLabels, actions).forEach {
      $0.0.attributedText = attributedStringWithFixedParagraphStyle(in: $0.1.description.attributedTitle)
    }
    // animateIfNeeded()
  }

  func reloadData(force: Bool = false) {
    if !force {
      guard buttons.count != actions.count else {
        reloadActions()
        return
      }
    }
    itemsContentView.subviews.forEach { $0.removeFromSuperview() }
    addLabels()
    addButtons()
  }

  func addButtons() {
    let style: ItemButton.Style = shouldTintIcons ? .tintIcon : .default
    buttons = actions.enumerated().map { index, action -> ItemButton in
      let button = ItemButton(actionItem: action, style: style)
      button.layer.shadowOpacity = Float(action.item.shadow.opacity)
      button.layer.shadowRadius = action.item.shadow.radius
      button.layer.shadowColor = action.item.shadow.color.cgColor
      button.layer.shadowOffset = CGSize(width: action.item.shadow.offset.x, height: action.item.shadow.offset.y)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.action = { [weak self] in
        self?.handle(action: action, at: index)
      }
      return button
    }
    buttons.reversed().forEach {
      itemsContentView.addSubview($0)
    }
    itemsContentView.interactiveViews = buttons
  }

  func addLabels() {
    descriptionLabels = actions.map { item -> UILabel in
      let label = UILabel()
      label.backgroundColor = .clear
      label.alpha = 0.0
      label.attributedText = attributedStringWithFixedParagraphStyle(in: item.description.attributedTitle)
      label.numberOfLines = 1
      return label
    }
    descriptionLabels.forEach {
      itemsContentView.addSubview($0)
    }
  }

  func attributedStringWithFixedParagraphStyle(in attributedString: NSAttributedString?) -> NSAttributedString? {
    guard let attributedString = attributedString else { return nil }

    let text = NSMutableAttributedString(attributedString: attributedString)
    let range = NSRange(location: 0, length: text.string.count)
    let currentParagraphStyle = text.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle
    let paragraphStyle = currentParagraphStyle?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
    paragraphStyle.alignment = .right
    text.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
    return text
  }

  // MARK: - Action

  func handle(action: Action, at index: Int) {
    guard index > 0 else {
      toggle()
      return
    }

    if state == .expanded || state == .expanding {
      action.handler?(index)
    }
    collapse()
  }

  // MARK: - Update

  func layout() {
    layoutButtons()
    layoutDescriptions()
  }

  func layoutButtons() {
    let buttonsLayout = calculateButtonsLayout(for: state)
    zip(buttons, buttonsLayout).forEach { button, frame in
      button.frame = frame
    }
  }

  func layoutDescriptions() {
    let descriptionsLayout = calculateDescriptionsLayout(for: state)
    zip(descriptionLabels, descriptionsLayout).forEach { label, frame in
      label.frame = frame
    }
  }

  func update() {
    let expand = state == .expanded || state == .expanding
    buttons.dropFirst().forEach {
      $0.alpha = expand ? 1.0 : 0.0
    }
    descriptionLabels.forEach {
      $0.alpha = expand ? 1.0 : 0.0
    }
  }

  // MARK: - Layout

  func calculateButtonsLayout(for state: State) -> [CGRect] {
    let bounds = itemsContentView.bounds
    let expand = state == .expanded || state == .expanding
    var accumulator: CGFloat = 0.0
    let buttonsLayout = buttons.enumerated().map { index, button -> CGRect in
      let selected = index == 0 && expand
      let size = selected ? button.actionItem.item.sizes.selected : button.actionItem.item.sizes.normal
      let offset = expand ? (size.height + itemSpacing) : 0.0
      let centerTranslation = (bounds.size.pointValue - size.pointValue) * 0.5
      let origin = CGPoint(x: 0.0, y: -accumulator) + centerTranslation
      let buttonFrame = CGRect(origin: origin, size: size)
      let result = convert(buttonFrame, to: itemsContentView)
      accumulator += offset
      return result
    }
    return buttonsLayout
  }

  func calculateDescriptionsLayout(for state: State, with buttonsLayout: [CGRect]? = nil) -> [CGRect] {
    let buttonsLayout = buttonsLayout ?? calculateButtonsLayout(for: state)
    let descriptionsLayout = zip(descriptionLabels, buttonsLayout).enumerated().map { index, item -> CGRect in
      let label = item.0
      let buttonFrame = item.1
      let offset = actions[safe: index]?.description.offset ?? .zero
      let size = label.attributedText?.sizeWith(fixedHeight: 128.0) ?? .zero
      let centerTranslation = (buttonFrame.size.pointValue - size.pointValue) * 0.5
      let origin = CGPoint(x: buttonFrame.minX - offset.x - size.width,
                           y: buttonFrame.minY - offset.y + centerTranslation.y)
      let frame = CGRect(origin: origin, size: size)
      return frame
    }
    return descriptionsLayout
  }
}
