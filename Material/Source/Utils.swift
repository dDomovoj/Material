//
//  Utils.swift
//  Floating Button
//
//  Created by Dmitry Duleba on 12/1/17.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Int

extension Int {

  static func random(max: UInt32 = .max) -> Int { return Int(truncatingIfNeeded: arc4random_uniform(max)) }
}

// MARK: - CGSize

extension CGSize {

  var pointValue: CGPoint { return CGPoint(x: width, y: height) }

  var rectValue: CGRect { return CGRect(origin: .zero, size: self) }

  var hashValue: Int { return width.hashValue ^ height.hashValue }
}

func * (left: CGSize, right: CGFloat) -> CGSize {
  return CGSize(width: left.width * right, height: left.height * right)
}

func * (left: CGFloat, right: CGSize) -> CGSize {
  return right * left
}

func * (left: CGSize, right: Double) -> CGSize {
  return CGSize(width: left.width * CGFloat(right), height: left.height * CGFloat(right))
}

func * (left: Double, right: CGSize) -> CGSize {
  return right * left
}

func / (left: CGSize, right: CGFloat) -> CGSize {
  return CGSize(width: left.width / right, height: left.height / right)
}

func / (left: CGSize, right: Double) -> CGSize {
  return CGSize(width: left.width / CGFloat(right), height: left.height / CGFloat(right))
}

// MARK: - CGPoint

extension CGPoint {

  func invert() -> CGPoint {
    return self * -1.0
  }

  func multiply(_ multiplier: CGFloat) -> CGPoint {
    return CGPoint(x: x * multiplier, y: y * multiplier)
  }
}

prefix func - (point: CGPoint) -> CGPoint {
  return point.invert()
}

func * (left: CGPoint, right: CGFloat) -> CGPoint {
  return left.multiply(right)
}

func * (left: CGFloat, right: CGPoint) -> CGPoint {
  return right.multiply(left)
}

func * (left: CGPoint, right: Double) -> CGPoint {
  return left.multiply(CGFloat(right))
}

func * (left: Double, right: CGPoint) -> CGPoint {
  return right.multiply(CGFloat(left))
}

func / (left: CGPoint, right: CGFloat) -> CGPoint {
  return left * (1.0 / right)
}

// MARK: - CGPoint.Vectors

func * (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

func / (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

// MARK: - Array

extension Array {

  subscript(safe idx: Int) -> Element? {
    return (0..<count).contains(idx) ? self[idx] : nil
  }
}

