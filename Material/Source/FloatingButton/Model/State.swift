//
//  State.swift
//  FloatingButton
//
//  Created by Dmitry Duleba on 9/26/17.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import Foundation

public extension FloatingButton {

  public enum State {
    case collapsed
    case expanding
    case expanded
    case collapsing

    public var isAnimating: Bool { return self == .collapsing || self == .expanding }
  }
}
