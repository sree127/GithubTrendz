//
//  Factory+Stack.swift
//  ApplePaySwag
//
//  Created by Sreejith Njamelil on 11.06.21.
//

import UIKit

public extension Factory {
  
  struct Stack {
    
    enum StackType {
      case horizontal(alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat)
      case vertical(alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat)
    }
    
    static func makeFrom(_ type: StackType) -> UIStackView {
      switch type {
      case let .horizontal(alignment, distribution, spacing):
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = alignment
        stack.distribution = distribution
        stack.spacing = spacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
      case let .vertical(alignment, distribution, spacing):
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = alignment
        stack.distribution = distribution
        stack.spacing = spacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
      }
    }
  }
}
