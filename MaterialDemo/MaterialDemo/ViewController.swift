//
//  ViewController.swift
//  MaterialDemo
//
//  Created by Dmitry Duleba on 12/1/17.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

  let filterButton = ItemFilterButton()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(filterButton)
    view.backgroundColor = .white
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let items = [
      Item(id: "1", text: "Item 1", description: "Description 1", image: nil, imageUrl: nil),
      Item(id: "2", text: nil, description: "Description 2", image: nil,
           imageUrl: "http://diylogodesigns.com/blog/wp-content/uploads/2016/04/Microsoft-Logo-icon-png-Transparent-Background.png"),
      Item(id: "3", text: nil, description: nil, image: #imageLiteral(resourceName: "image"), imageUrl: nil)
    ]
    filterButton.shouldShowAll = true
    filterButton.items = items
    filterButton.reloadData()
  }

  override func updateViewConstraints() {
    super.updateViewConstraints()
    filterButton.snp.remakeConstraints {
      $0.right.bottom.equalToSuperview().inset(ItemFilterButton.Size.padding * 2.0)
      $0.size.equalTo(ItemFilterButton.Size.size)
    }
  }
}

