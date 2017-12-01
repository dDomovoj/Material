//
//  AnimationBubble.swift
//  FloatingButton
//
//  Created by Dmitry Duleba on 9/26/17.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import UIKit

extension FloatingButton {

  struct Timings {

    let baseDelay: TimeInterval
    let delayOffset: TimeInterval
    let duration: TimeInterval
    let totalDuration: TimeInterval

    init(with baseDuration: TimeInterval, itemsCount: Int) {
      let animationDuration = baseDuration * 2.0 + baseDuration * Double(itemsCount)
      let dimming_real_duration = min(animationDuration, 0.3)
      let item_start_inDimming = 1.0 / 6.0
      let item_duration_inDimming = 3.0 / 3.0
      let item_offset_inItems = 1.0 / 3.0

      let count = Double(max(0, itemsCount - 1))
      let dimming_duration = animationDuration /
        (item_start_inDimming + item_duration_inDimming * (1.0 + count * item_offset_inItems))
      baseDelay = dimming_duration * item_start_inDimming
      duration = dimming_duration * item_duration_inDimming
      delayOffset = duration * item_offset_inItems
      totalDuration = max(dimming_real_duration, baseDelay + count * delayOffset + duration)
    }
  }

  func bubbleExpansionAnimation(with animationId: Int) {
    let count = actions.count
    let timings = Timings(with: animation.duration, itemsCount: count)
    let collapsedButtonsLayout = calculateButtonsLayout(for: .collapsed)
    let expandedButtonsLayout = calculateButtonsLayout(for: .expanded)
    let expandedDecriptionsLayout = calculateDescriptionsLayout(for: .expanded)

    prepareExpandAnimation(collapsedButtonsLayout, expandedButtonsLayout, expandedDecriptionsLayout)
    startExpandAnimation(timings, expandedButtonsLayout)
    finilizeExpandAnimation(timings, animationId)
  }

  func bubbleCollapseAnimation(with animationId: Int) {
    let count = actions.count
    let timings = Timings(with: animation.duration, itemsCount: count)
    let collapsedButtonsLayout = calculateButtonsLayout(for: .collapsed)
    let expandedDecriptionsLayout = calculateDescriptionsLayout(for: .expanded)

    prepareBubbleCollapseAnimation(expandedDecriptionsLayout)
    startBubbleCollapseAnimation(timings, collapsedButtonsLayout)
    finilizeBubbleCollapseAnimation(timings, animationId)
  }
}

// MARK: - Private.ExpandAnimation

fileprivate extension FloatingButton {

  func prepareExpandAnimation(_ collapsedButtonsLayout: [CGRect],
                              _ expandedButtonsLayout: [CGRect], _ expandedDecriptionsLayout: [CGRect]) {
    buttons.enumerated().forEach { index, button in
      if index == 0 {
        button.frame = collapsedButtonsLayout[safe: index] ?? button.frame
      } else {
        button.frame = expandedButtonsLayout[safe: index] ?? button.frame
        button.layer.opacity = 0.0
        button.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1.0)
      }
    }
    descriptionLabels.enumerated().forEach { index, label in
      label.frame = expandedDecriptionsLayout[safe: index] ?? label.frame
      let offset = -CGPoint(x: label.frame.midX, y: 0.0)
      label.layer.opacity = 0.0
      label.layer.transform = CATransform3DMakeTranslation(offset.x, offset.y, 0.0)
    }
  }

  func startExpandAnimation(_ timings: FloatingButton.Timings, _ expandedButtonsLayout: [CGRect]) {
    buttons.enumerated().forEach { index, button in
      let options: UIViewAnimationOptions = [.allowUserInteraction, .layoutSubviews, .beginFromCurrentState]
      let delay = timings.baseDelay + timings.delayOffset * Double(index)
      let duration = timings.duration * ((index == 0) ? 2.5 : 1.0)
      let velocity = CGFloat(duration)
      UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 1.0,
                     initialSpringVelocity: velocity, options: options, animations: {
                      if index == 0 {
                        button.frame = expandedButtonsLayout[safe: index] ?? button.frame
                      } else {
                        button.layer.opacity = 1.0
                        button.layer.transform = CATransform3DIdentity
                      }
      }, completion: nil)
    }

    descriptionLabels.enumerated().forEach { index, label in
      let options: UIViewAnimationOptions = [.allowUserInteraction, .layoutSubviews]
      let duration = timings.duration
      let delay = timings.baseDelay + timings.delayOffset * Double(index) + duration * 0.3
      UIView.animate(withDuration: duration * 0.7, delay: delay, options: options, animations: {
        label.layer.opacity = 1.0
        label.layer.transform = CATransform3DIdentity
      }, completion: nil)
    }
  }

  func finilizeExpandAnimation(_ timings: FloatingButton.Timings, _ animationId: Int) {
    DispatchQueue.main.asyncAfter(deadline: .now() + timings.totalDuration) {
      self.finalizeAnimation(with: animationId)
    }
  }
}

// MARK: - Private.CollapseAnimation

fileprivate extension FloatingButton {

  func prepareBubbleCollapseAnimation(_ expandedDecriptionsLayout: [CGRect]) {
    zip(descriptionLabels, expandedDecriptionsLayout).forEach { element in
      element.0.frame = element.1
    }
  }

  func startBubbleCollapseAnimation(_ timings: FloatingButton.Timings, _ collapsedButtonsLayout: [CGRect]) {
    let options: UIViewAnimationOptions = [.allowUserInteraction, .layoutSubviews]
    let velocity = CGFloat(timings.duration)
    UIView.animate(withDuration: animation.duration * 3.0, delay: 0.0, usingSpringWithDamping: 1.0,
                   initialSpringVelocity: velocity, options: options, animations: {
                    if let button = self.buttons.first {
                      button.frame = collapsedButtonsLayout[safe: 0] ?? button.frame
                      button.setNeedsLayout()
                    }
    }, completion: nil)

    buttons.dropFirst().reversed().enumerated().forEach { index, button in
      let delay = timings.delayOffset * Double(index)
      let duration = timings.duration
      UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
        button.layer.opacity = 0.0
        button.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1.0)
      }, completion: { finished in
        guard finished else { return }

        button.layer.transform = CATransform3DIdentity
        button.frame = collapsedButtonsLayout[safe: index] ?? button.frame
      })
    }

    descriptionLabels.reversed().enumerated().forEach { index, label in
      let options: UIViewAnimationOptions = [.allowUserInteraction, .layoutSubviews]
      let duration = timings.duration
      let delay = timings.delayOffset * Double(index)
      UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
        let offset = -CGPoint(x: label.frame.midX, y: 0.0)
        label.layer.transform = CATransform3DMakeTranslation(offset.x, offset.y, 0.0)
        label.layer.opacity = 0.0
      }, completion: { finished in
        guard finished else { return }

        label.layer.transform = CATransform3DIdentity
      })
    }
  }

  func finilizeBubbleCollapseAnimation(_ timings: FloatingButton.Timings, _ animationId: Int) {
    let delay: TimeInterval
    if let delta = previousAnimationTimestampDelta, delta < timings.totalDuration {
      delay = max(delta, timings.duration * 2.0)
    } else {
      delay = timings.totalDuration
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
      self.itemsContentView.layer.removeAllAnimations()
      self.buttons.enumerated().forEach {
        $0.element.layer.removeAllAnimations()
        $0.element.layer.opacity = $0.offset == 0 ? 1.0 : 0.0
        $0.element.layer.transform = CATransform3DIdentity
      }
      self.descriptionLabels.forEach {
        $0.layer.removeAllAnimations()
        $0.layer.opacity = 0.0
        $0.layer.transform = CATransform3DIdentity
      }
      self.finalizeAnimation(with: animationId)
    }
  }
}
