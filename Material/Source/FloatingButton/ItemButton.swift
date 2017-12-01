//
//  ItemButton.swift
//  FloatingButton
//
//  Created by Dmitry Duleba on 9/26/17.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

extension FloatingButton {

  class ItemButton: CircleButton {

    enum Style {
      case `default`
      case tintIcon
    }

    var actionItem: Action { didSet { update() } }

    private let style: Style

    private let imageView = UIImageView()
    private let titleLabel = UILabel()

    required init(actionItem: Action, style: Style) {
      self.actionItem = actionItem
      self.style = style
      super.init(frame: CGRect(origin: .zero, size: actionItem.item.sizes.normal))
    }

    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override func setup() {
      super.setup()
      let target: UIView
      switch style {
      case .tintIcon: target = contentView
      case .default: target = self
      }
      target.addSubview(imageView)
      target.addSubview(titleLabel)
      imageView.contentMode = .scaleAspectFit
      titleLabel.contentMode = .scaleAspectFit
      update()
    }

    func update() {
      showContent()
      backgroundColor = actionItem.item.colors.primary
      selectionColor = actionItem.item.colors.selected
      highlightColor = actionItem.item.colors.highlighted
      setNeedsLayout()
      //    layoutIfNeeded()
    }

    func showContent() {
      imageView.image = nil
      titleLabel.text = nil

      if let image = actionItem.item.image {
        imageView.image = image
      }
      if let imageInterceptor = actionItem.item.imageInterceptor {
        imageInterceptor(imageView)
      }
      if let textInterceptor = actionItem.item.textInterceptor {
        textInterceptor(titleLabel)
      }
    }

    override func layoutSubviews() {
      super.layoutSubviews()
      // TODO: Make options for sizing
      //    let maxSize = bounds.size * 1.0 // 0.5
      //    let size = (imageView.image?.size ?? .zero) * (imageView.image?.scale ?? 1.0)
      //    let multiplier = max(maxSize.width / size.width, maxSize.height / size.height).clamp(0.0, 1.0)
      //    imageView.bounds = CGRect(origin: .zero, size: size * multiplier).integral
      imageView.bounds = CGRect(origin: .zero, size: bounds.size * 0.7)
      imageView.center = bounds.size.pointValue * 0.5
      titleLabel.frame = imageView.frame
    }
  }
}
