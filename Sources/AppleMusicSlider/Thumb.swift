//
//  Thumb.swift
//  SoundHit
//
//  Created by Ivan De Martino on 11/15/20.
//  Copyright © 2020 Ivan De Martino. All rights reserved.
//

import UIKit

final class Thumb: UIImageView {

  // MARK: - Constants
  private enum ThumbConstants {
    static let thumbShadowOpacity: Float = 0.3
    static let thumShadowRadius: CGFloat = 3.0
    static let scaleFactor: CGFloat = 3.0
  }

  // MARK: - Private Properties
  private var color: UIColor?

  lazy private var smallThumb: UIView = {
    let view = UIImageView()
    view.isUserInteractionEnabled = false
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = Constants.kThumbSmallSize / 2
    view.layer.shadowOpacity = ThumbConstants.thumbShadowOpacity
    view.layer.shadowRadius = ThumbConstants.thumShadowRadius
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = .zero
    return view
  }()

  // MARK: - Initializers

  init(frame: CGRect, color: UIColor) {
    self.color = color
    super.init(frame: frame)
    finishInt()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    finishInt()
  }

  // MARK: - Public Methods


  /// Tranforms thumb view back to identity.
  /// - Parameter color: a color thar will appear in the end of animation.
  func setUpIdentity() {
    smallThumb.transform = .identity
    smallThumb.backgroundColor = color
  }


  /// Transforms the thumb view size and change the color.
  /// - Parameter color: a color that will appear during animation
  func increaseSize(with color: UIColor) {
    var transform = CGAffineTransform.identity
    transform = transform.scaledBy(x: ThumbConstants.scaleFactor, y: ThumbConstants.scaleFactor)
    smallThumb.transform = transform
    smallThumb.backgroundColor = color
  }

  // MARK: - Private Methods

  private func finishInt() {
    setUpView()
    setUpConstraints()
  }

  private func setUpView() {
    backgroundColor = .clear
    frame.size = .zero
    addSubview(smallThumb)
    smallThumb.backgroundColor = color
  }

  private func setUpConstraints() {
    NSLayoutConstraint.activate([
      smallThumb.centerYAnchor.constraint(equalTo: centerYAnchor),
      smallThumb.centerXAnchor.constraint(equalTo: centerXAnchor),
      smallThumb.heightAnchor.constraint(equalTo: smallThumb.widthAnchor),
      smallThumb.widthAnchor.constraint(equalToConstant: Constants.kThumbSmallSize)
    ])
  }
}

