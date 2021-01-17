//
//  CustomSlider.swift
//  SoundHit
//
//  Created by Ivan De Martino on 1/16/21.
//  Copyright © 2021 Ivan De Martino. All rights reserved.
//

import UIKit

class Slider: UIControl {

  // MARK: - Constants

  private enum Constants {
    static let kOne: CGFloat = 1.0
    static let animationDuration: TimeInterval = 0.2
    static let thumbShadowOpacity: Float = 0.3
    static let thumShadowRadius: CGFloat = 3.0
  }

  // MARK: - Public Properties

  private(set) var primaryColor: UIColor = UIColor.red
  private(set) var secondaryColor: UIColor = UIColor.orange

  // MARK: - Private Properties
  private let minValue: CGFloat = .zero
  private let maxValue: CGFloat = Constants.kOne
  private var previousTouchLocation: CGPoint = .zero

  private var value: CGFloat = .zero

  private var halfThumbWidth: CGFloat {
    return thumb.bounds.width / 2
  }

  // MARK: - IBOutlets
  private var thumbLeadingConstraint: NSLayoutConstraint!
  private var thumbHeightConstraint: NSLayoutConstraint!
  private var filledBackgroundWidthConstraint: NSLayoutConstraint!

  private lazy var backgroundView: UIView = {
    let view = UIView()
    view.backgroundColor = .gray
    view.translatesAutoresizingMaskIntoConstraints = false
    view.isUserInteractionEnabled = false
    return view
  }()

  private lazy var filledBackgroundView: UIView = {
    let view = UIView()
    view.backgroundColor = primaryColor
    view.translatesAutoresizingMaskIntoConstraints = false
    view.isUserInteractionEnabled = false
    return view
  }()

  private lazy var thumb: Thumb = {
    let thumb = Thumb(frame: frame, color: primaryColor)
    thumb.translatesAutoresizingMaskIntoConstraints = false
    return thumb
  }()

  // MARK: - Initializers

  override init(frame: CGRect) {
    super.init(frame: frame)
    finishInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    finishInit()
  }

  private func finishInit() {
    setUpView()
    setUpConstraints()
  }

  // MARK: - Private Methods

  private func setUpView() {
    addSubview(backgroundView)
    addSubview(filledBackgroundView)
    addSubview(thumb)
    backgroundColor = .white
  }

  private func setUpConstraints() {
    setUpFilledBackgroundViewConstraints()
    setUpBackgroundViewConstraints()
    setUpThumbConstraints()
  }

  private func setUpBackgroundViewConstraints() {
    NSLayoutConstraint.activate([
      backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
      backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
      backgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
      backgroundView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1, constant: .zero)
    ])
  }

  private func setUpFilledBackgroundViewConstraints() {
    filledBackgroundWidthConstraint = filledBackgroundView.widthAnchor.constraint(equalToConstant: .zero)
    NSLayoutConstraint.activate([
      filledBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
      filledBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
      filledBackgroundView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1, constant: .zero),
      filledBackgroundWidthConstraint
    ])
  }

  private func setUpThumbConstraints() {
    thumbLeadingConstraint = thumb.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -frame.height/2)
    thumbHeightConstraint = thumb.heightAnchor.constraint(equalTo: heightAnchor)
    NSLayoutConstraint.activate([
      thumb.centerYAnchor.constraint(equalTo: centerYAnchor),
      thumb.widthAnchor.constraint(equalTo: thumb.heightAnchor),
      thumbLeadingConstraint,
      thumbHeightConstraint
    ])
  }

  private func boundValue(
    _ value: CGFloat,
    toLowerValue lowerValue: CGFloat,
    andUpperValue upperValue: CGFloat) -> CGFloat {
    return min(max(value, lowerValue), upperValue)
  }

  // MARK: - Animations

  private func animateBeginTracking() {
    UIView.animate(
      withDuration: Constants.animationDuration,
      delay: .zero,
      options: [.curveLinear],
      animations: { [weak self] in
        guard let self = self else { return }
        self.thumb.startAnimation(with: self.secondaryColor)
        self.filledBackgroundView.backgroundColor = self.secondaryColor
        self.setNeedsLayout()
    })
  }

  private func animateEndTracking() {
    UIView.animate(
      withDuration: Constants.animationDuration,
      delay: .zero,
      options: [.curveLinear],
      animations: { [weak self] in
        guard let self = self else { return }
        self.thumb.endAnimation(with: self.primaryColor)
        self.filledBackgroundView.backgroundColor = self.primaryColor
        self.setNeedsLayout()
    })
  }
}

// MARK: - Override UIControl

extension Slider {

  override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    super.beginTracking(touch, with: event)

    previousTouchLocation = touch.location(in: self)
    if thumb.frame.contains(previousTouchLocation) {
      thumb.isHighlighted = true
      animateBeginTracking()
    }
    return thumb.isHighlighted
  }

  override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    super.continueTracking(touch, with: event)

    let touchLocation = touch.location(in: self)
    let deltaLocation = touchLocation.x - previousTouchLocation.x
    let deltaValue = (maxValue - minValue) * deltaLocation / bounds.width

    previousTouchLocation = touchLocation
    value = boundValue(value + deltaValue, toLowerValue: minValue, andUpperValue: maxValue)

    let range = backgroundView.bounds.minX...backgroundView.frame.width

    if thumb.isHighlighted, range.contains(touchLocation.x) {
      thumbLeadingConstraint.constant = touchLocation.x - halfThumbWidth
      filledBackgroundWidthConstraint.constant = touchLocation.x
    }
    sendActions(for: .valueChanged)
    return true
  }

  override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
    super.endTracking(touch, with: event)
    thumb.isHighlighted = false
    animateEndTracking()
    sendActions(for: .editingDidEnd)
  }

  override func cancelTracking(with event: UIEvent?) {
    super.cancelTracking(with: event)
    thumb.isHighlighted = false
    animateEndTracking()
    sendActions(for: .editingDidEnd)
  }
}
