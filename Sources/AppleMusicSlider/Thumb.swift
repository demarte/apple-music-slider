//
//  Thumb.swift
//  SoundHit
//
//  Created by Ivan De Martino on 11/15/20.
//  Copyright © 2020 Ivan De Martino. All rights reserved.
//

import UIKit

class Thumb: UIImageView {

  // MARK: - Constants
  private enum Constants {
    static let thumbShadowOpacity: Float = 0.3
    static let thumShadowRadius: CGFloat = 3.0
    static let thumbSmallSize: CGFloat = 8.0
    static let scaleFactor: CGFloat = 3.0
  }

  // MARK: - Private Properties
  private var color: UIColor?

  lazy private var smallThumb: UIView = {
    let view = UIImageView()
    view.isUserInteractionEnabled = false
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = Constants.thumbSmallSize / 2
    view.layer.shadowOpacity = Constants.thumbShadowOpacity
    view.layer.shadowRadius = Constants.thumShadowRadius
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

  func endAnimation(with color: UIColor) {
    smallThumb.transform = .identity
    smallThumb.backgroundColor = color
  }

  func startAnimation(with color: UIColor) {
    var transform = CGAffineTransform.identity
    transform = transform.scaledBy(x: Constants.scaleFactor, y: Constants.scaleFactor)
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
      smallThumb.widthAnchor.constraint(equalToConstant: Constants.thumbSmallSize)
    ])
  }
}
