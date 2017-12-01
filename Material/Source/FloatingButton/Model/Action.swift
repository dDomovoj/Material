//
//  Action.swift
//  FloatingButton
//
//  Created by Dmitry Duleba on 9/26/17.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import UIKit

public extension FloatingButton {
  public struct Action {

    public var description: Description
    public var item: Item
    public var handler: ((Int) -> Void)?

    public init(description: Description? = nil, item: Item? = nil, handler: ((Int) -> Void)? = nil) {
      self.description = description ?? Description()
      self.item = item ?? Item()
      self.handler = handler
    }
  }
}

// MARK: Action.Description

extension FloatingButton.Action {

  public struct Description {
    var attributedTitle: NSAttributedString?
    var offset: CGPoint = CGPoint(x: 64.0, y: 0.0)

    public init(_ attributedTitle: NSAttributedString? = nil, offset: CGPoint? = nil) {
      self.attributedTitle = attributedTitle
      self.offset = offset ?? CGPoint(x: 64.0, y: 0.0)
    }
  }
}

// MARK: - Action.Item

extension FloatingButton.Action {

  public typealias ImageInterceptor = (UIImageView) -> Void
  public typealias TextInterceptor = (UILabel) -> Void

  public struct Item {
    let image: UIImage?
    let imageInterceptor: ImageInterceptor?
    let textInterceptor: TextInterceptor?
    let colors: Colors
    let sizes: Sizes
    let shadow: Shadow

    public init(image: UIImage? = nil, imageInterceptor: ImageInterceptor? = nil,
                textInterceptor: TextInterceptor? = nil, colors: Colors? = nil,
                sizes: Sizes? = nil, shadow: Shadow? = nil) {
      self.image = image
      self.imageInterceptor = imageInterceptor
      self.textInterceptor = textInterceptor
      self.colors = colors ?? Colors()
      self.sizes = sizes ?? Sizes()
      self.shadow = shadow ?? Shadow()
    }
  }
}

// MARK: - Action.Item.Colors

extension FloatingButton.Action.Item {

  public struct Colors {
    let primary: UIColor
    let selected: UIColor
    let highlighted: UIColor

    public init(primary: UIColor? = nil, selected: UIColor? = nil, highlighted: UIColor? = nil) {
      let color: UIColor = primary ?? .white
      self.primary = color
      self.selected = selected ?? color.withAlphaComponent(0.05)
      self.highlighted = highlighted ?? color.withAlphaComponent(0.1)
    }
  }
}

// MARK: - Action.Item.Sizes

extension FloatingButton.Action.Item {

  public struct Sizes {
    let normal: CGSize
    let selected: CGSize
    
    public init(normal: CGSize? = nil, selected: CGSize? = nil) {
      let size: CGSize = normal ?? CGSize(width: 64.0, height: 64.0)
      self.normal = size
      self.selected = selected ?? size * 1.15
    }
  }
}

// MARK: - Action.Item.Shadow

extension FloatingButton.Action.Item {

  public struct Shadow {
    let offset: CGPoint
    let color: UIColor
    let opacity: CGFloat
    let radius: CGFloat

    public init(color: UIColor? = nil, opacity: CGFloat? = nil, radius: CGFloat? = nil, offset: CGPoint? = nil) {
      self.color = color ?? UIColor.black.withAlphaComponent(0.35)
      self.opacity = opacity ?? 1.0
      self.offset = offset ?? CGPoint(x: 1.0, y: 1.0)
      self.radius = radius ?? 2.0
    }
  }
}
