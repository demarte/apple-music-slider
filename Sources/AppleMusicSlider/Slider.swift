//
//  CustomSlider.swift
//  SoundHit
//
//  Created by Ivan De Martino on 1/16/21.
//  Copyright © 2021 Ivan De Martino. All rights reserved.
//

import UIKit

// MARK: - Enums

fileprivate enum Direction {
  case up
  case down
}

public final class Slider: UIControl {

  // MARK: - Constants

  private enum SliderConstants {
    static let kOne: CGFloat = 1.0
    static let kTwo: CGFloat = 2.0
    static let animationDuration: TimeInterval = 0.2
    static let thumbShadowOpacity: Float = 0.3
    static let thumShadowRadius: CGFloat = 3.0
    static let kMultiplier: CGFloat = 0.1
    static let kValueIncrement: CGFloat = 0.1
  }

  private enum AccessibilityStrings {
    static let kSliderLabel = "Track Position"
  }

  // MARK: - Public Properties

  public var value: CGFloat = .zero

  // MARK: - Private Properties

  private let minValue: CGFloat = .zero
  private let maxValue: CGFloat = SliderConstants.kOne
  private var primaryColor: UIColor = UIColor.red
  private var secondaryColor: UIColor = UIColor.orange
  private var previousTouchLocation: CGPoint = .zero
  private let valueIncrement: CGFloat = SliderConstants.kValueIncrement

  // MARK: - IBOutlets

  private var thumbLeadingConstraint: NSLayoutConstraint!
  private var thumbHeightConstraint: NSLayoutConstraint!
  private var filledBackgroundWidthConstraint: NSLayoutConstraint!

  // MARK: - Private Properties

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

  // MARK: - Private Computed Properties

  private var halfThumbWidth: CGFloat {
    return thumb.bounds.width / SliderConstants.kTwo
  }

  /// Here frame's height is the same as thumb height and thumb width.
  private var thumbInitialPosition: CGFloat {
    return -(frame.height / SliderConstants.kTwo) + (Constants.kThumbSmallSize / SliderConstants.kTwo)
  }

  private var thumbFinalPosition: CGFloat {
    return backgroundView.bounds.width - (frame.height / SliderConstants.kTwo) - (Constants.kThumbSmallSize / SliderConstants.kTwo)
  }

  // MARK: - Initializers

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    finishInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    finishInit()
  }

  private func finishInit() {
    setUpView()
    setUpAccessibilityElements()
    setUpConstraints()
  }

  // MARK: - Public Methods


  /// Sets up the slider with primary and secondary color.
  /// - Parameters:
  ///   - primaryColor: the default color of slider.
  ///   - secondaryColor: the color of slider when the animation is running.
  public func setUpSlider(primaryColor: UIColor, secondaryColor: UIColor) {
    self.primaryColor = primaryColor
    self.secondaryColor = secondaryColor
  }

  /// Updates slider value and adjusts the position of thumb
  /// - Parameter value: Slider value.
  public func updateSlider(value: Double) {
    self.value = CGFloat(value)
    updateThumbPosition()
  }

  // MARK: - Private Methods

  private func setUpView() {
    addSubview(backgroundView)
    addSubview(filledBackgroundView)
    addSubview(thumb)
    backgroundColor = .clear
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
      backgroundView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: SliderConstants.kMultiplier, constant: .zero)
    ])
  }

  private func setUpFilledBackgroundViewConstraints() {
    filledBackgroundWidthConstraint = filledBackgroundView.widthAnchor.constraint(equalToConstant: .zero)
    NSLayoutConstraint.activate([
      filledBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
      filledBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
      filledBackgroundView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: SliderConstants.kMultiplier, constant: .zero),
      filledBackgroundWidthConstraint
    ])
  }

  private func setUpThumbConstraints() {
    thumbLeadingConstraint = thumb.leadingAnchor.constraint(equalTo: leadingAnchor, constant: thumbInitialPosition)
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

  private func updateThumbPosition() {
    let deltaWidth = thumbFinalPosition - thumbInitialPosition
    let offset = halfThumbWidth - (Constants.kThumbSmallSize / SliderConstants.kTwo)
    let thumbPosition = value * deltaWidth - offset
    let filledBackgroundPosition = value * backgroundView.bounds.width
    thumbLeadingConstraint.constant = thumbPosition
    filledBackgroundWidthConstraint.constant = filledBackgroundPosition
  }

  // MARK: - Animations

  private func animateBeginTracking() {
    UIView.animate(
      withDuration: SliderConstants.animationDuration,
      delay: .zero,
      options: [.curveLinear],
      animations: { [weak self] in
        guard let self = self else { return }
        self.thumb.increaseSize(with: self.secondaryColor)
        self.filledBackgroundView.backgroundColor = self.secondaryColor
        self.setNeedsLayout()
    })
  }

  private func animateEndTracking() {
    UIView.animate(
      withDuration: SliderConstants.animationDuration,
      delay: .zero,
      options: [.curveLinear],
      animations: { [weak self] in
        guard let self = self else { return }
        self.thumb.setUpIdentity()
        self.filledBackgroundView.backgroundColor = self.primaryColor
        self.setNeedsLayout()
    })
  }

  // MARK: - Accessibility Features

  public override var accessibilityValue: String? {
    get {
      return "\(Int(value * 10)))"
    }
    set {
      super.accessibilityValue = newValue
    }
  }

  private func setUpAccessibilityElements() {
    isAccessibilityElement = true
    accessibilityTraits = .adjustable
    accessibilityLabel = AccessibilityStrings.kSliderLabel
  }
}

// MARK: - Override UIControl

extension Slider {

  public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    super.beginTracking(touch, with: event)

    previousTouchLocation = touch.location(in: self)
    if thumb.frame.contains(previousTouchLocation) {
      thumb.isHighlighted = true
      animateBeginTracking()
    }
    return thumb.isHighlighted
  }

  public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    super.continueTracking(touch, with: event)

    let touchLocation = touch.location(in: self)
    let deltaLocation = touchLocation.x - previousTouchLocation.x
    let deltaValue = (maxValue - minValue) * deltaLocation / bounds.width

    previousTouchLocation = touchLocation
    value = boundValue(value + deltaValue, toLowerValue: minValue, andUpperValue: maxValue)

    let range = backgroundView.bounds.minX...backgroundView.frame.width

    if thumb.isHighlighted, range.contains(touchLocation.x) {
      thumbLeadingConstraint.constant = boundValue(touchLocation.x - halfThumbWidth, toLowerValue: thumbInitialPosition, andUpperValue: thumbFinalPosition)
      filledBackgroundWidthConstraint.constant = touchLocation.x
    }
    sendActions(for: .valueChanged)
    return true
  }

  public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
    super.endTracking(touch, with: event)
    thumb.isHighlighted = false
    animateEndTracking()
    sendActions(for: .editingDidEnd)
  }

  public override func cancelTracking(with event: UIEvent?) {
    super.cancelTracking(with: event)
    thumb.isHighlighted = false
    animateEndTracking()
    sendActions(for: .editingDidEnd)
  }
}


