//
//  UIStackView+Extensions.swift
//
//  Created by Sreejith Njamelil on 11.06.21.
//

import UIKit

public extension UIStackView {
  
  /// Helper for arranging the subviews in the stackview and then applying layout constrains
  /// - Parameters:
  ///   - subview: subView that needs to be added to UIStackView
  ///   - constraints: layout constrains that needs to be applied
  /// - Returns: subView
  @discardableResult func addArrangedSubview<T: UIView>(_ subview: T, constraints: [NSLayoutConstraint]) -> T {
    subview.translatesAutoresizingMaskIntoConstraints = false
    addArrangedSubview(subview)
    NSLayoutConstraint.activate(constraints)
    return subview
  }
}
