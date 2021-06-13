//
//  ActivityIndicatorButton.swift
//  ApplePaySwag
//
//  Created by Sreejith Njamelil on 12.06.21.
//  Copyright © 2021 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit

/// Button with ActivityIndicator feature
final public class ActivityIndicatorButton: UIButton {
  
  init() {
    super.init(frame: .zero)
    
    layoutActivityIndicator()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI Components
  private lazy var activityIndicator: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.hidesWhenStopped = true
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.color = .white
    return activityIndicator
  }()
}

// MARK: - Layout
extension ActivityIndicatorButton {
  private func layoutActivityIndicator() {
    addSubview(activityIndicator)
    NSLayoutConstraint.activate([
      activityIndicator.trailingAnchor.constraint(equalTo: centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
}

// MARK: - Interface
public extension ActivityIndicatorButton {
  func startAnimating() {
    activityIndicator.startAnimating()
  }
  
  func stopAnimating() {
    guard activityIndicator.isAnimating else { return }
    activityIndicator.stopAnimating()
  }
}
