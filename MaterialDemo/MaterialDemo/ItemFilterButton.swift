//
//  ItemFilterButton
//  MaterialDemo
//
//  Created by Dmitry Duleba on 12/1/17.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import UIKit
import Material
import SnapKit
import SwiftyAttributes
import Kingfisher

struct Item {
  let id: String
  let text: String?
  let description: String?
  let image: UIImage?
  let imageUrl: String?
}

class ItemFilterButton: UIView {

  enum Size {

    static let size: CGFloat = 70.0
    static let padding: CGFloat = 15.0
  }

  enum Filter: Equatable {

    case item(Item)
    case all
    case selector

    static func ==(lhs: Filter, rhs: Filter) -> Bool {
      switch (lhs, rhs) {
      case (.item(let lhs), .item(let rhs)): return lhs.id == rhs.id
      case (.all, .all): return true
      case (.selector, .selector): return true
      default: return false
      }
    }

    fileprivate var title: String? {
      switch self {
      case .item(let item):
        return item.text
      case .all: return "ALL"
      case .selector: return nil
      }
    }

    fileprivate var imageUrl: String? {
      switch self {
      case .item(let item): return item.imageUrl
      case .selector: return "https://diylogodesigns.com/blog/wp-content/uploads/2016/04/Microsoft-Logo-icon-png-Transparent-Background.png"
      default: return nil
      }
    }

    fileprivate var image: UIImage? {
      switch self {
      case .item(let item): return item.image
      default: return nil
      }
    }

    fileprivate var descriptionTitle: String? {
      switch self {
      case .item(let item): return item.description
      case .selector: return "selector"
      default: return nil
      }
    }
  }

  private var filters: [Filter] = []

  var filter: Filter? { return filters.first }
  var selector: ((Filter) -> Void)?

  var shouldShowAll: Bool = false {
    didSet {
      if let index = filters.index(of: .all) {
        filters.remove(at: index)
      }
      if shouldShowAll {
        filters.insert(.all, at: 0)
      }
    }
  }

  var items: [Item] = [] {
    didSet {
      let count = TimeInterval(max(items.count, 1))
      let offset = (count - 1.0) * 0.075
      floatingButton.animation.duration = (0.2 + offset) / count
      filters = items.map { Filter.item($0) }
      if shouldShowAll {
        filters.insert(.all, at: 0)
      }
      filters.insert(.selector, at: 0)
    }
  }

  private let floatingButton = FloatingButton()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupView() {
    addSubview(floatingButton)
    floatingButton.animation.animationType = .bubble
    floatingButton.snp.remakeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  func select(filter: Filter) {
    guard let index = filters.index(of: filter) else { return }

    let selectedFilter = filters.remove(at: index)
    filters.insert(selectedFilter, at: 0)
    reloadData()
  }

  typealias Action = FloatingButton.Action
  func reloadData() {
    floatingButton.actions = filters.map { filter -> Action  in
      let title = filter.descriptionTitle?
        .withFont(UIFont.systemFont(ofSize: 18.0))
        .withTextColor(UIColor.white)
      let description = Action.Description(title, offset: CGPoint(x: 10.0, y: 0.0))
      let color = UIColor.white
      let highlighted = UIColor.lightGray.withAlphaComponent(0.3)
      let colors = Action.Item.Colors(primary: color, selected: color, highlighted: highlighted)
      let shadow = Action.Item.Shadow(color: UIColor.black, opacity: 0.5, radius: 3.0, offset: CGPoint(x: 3.0, y: 3.0))
      let normalSize = CGSize(width: Size.size, height: Size.size)
      let selectedSize = CGSize(width: Size.size * 1.1, height: Size.size * 1.1)
      let sizes = Action.Item.Sizes(normal: normalSize, selected: selectedSize)
      let item = Action.Item(image: filter.image, imageInterceptor: { imageView in
        if let imageUrl = filter.imageUrl {
          let url = URL(string: imageUrl)
          imageView.kf.setImage(with: url)
        }
      }, textInterceptor: { label in
        if let title = filter.title {
          label.textAlignment = .center
          label.textColor = UIColor.white
          label.font = UIFont.systemFont(ofSize: 12.0)
          label.text = title
        }
      }, colors: colors, sizes: sizes, shadow: shadow)
      let action = Action(description: description, item: item, handler: { [weak self] _ in
        self?.select(filter: filter)
        self?.selector?(filter)
      })
      return action
    }
  }}
