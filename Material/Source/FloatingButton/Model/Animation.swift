//
//  Animation.swift
//  FloatingButton
//
//  Created by Dmitry Duleba on 9/26/17.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import Foundation

public extension FloatingButton {
  
  public enum AnimationType {
    case slideUp
    case bubble
    case none
    //  TODO: AnimationType
  }

  public struct Animation {
    public var duration: TimeInterval = 0.3
    public var animationType: AnimationType = .slideUp

    public init(type: AnimationType? = nil, duration: TimeInterval? = nil) {
      self.animationType = type ?? .slideUp
      self.duration = duration ?? 0.3
    }
  }
}
