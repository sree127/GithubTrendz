//
//  Factory+Button.swift
//  ApplePaySwag
//
//  Created by Sreejith Njamelil on 11.06.21.
//  Copyright © 2021 Razeware LLC. All rights reserved.
//

import UIKit

extension Factory {
  
  struct UIButtons {
    
    enum ActivityIndicator: FactoryMethod {
      
      enum ButtonType {
        case primary(text: String? = nil)
      }
      
      static func makeFrom(_ type: ButtonType) -> ActivityIndicatorButton {
        let button = ActivityIndicatorButton()
        switch type {
        case let .primary(text):
          button.translatesAutoresizingMaskIntoConstraints = false
          button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
          button.backgroundColor = .systemBlue
          button.layer.cornerRadius = 18
          button.contentEdgeInsets.left = 16
          button.contentEdgeInsets.right = 16
          button.contentEdgeInsets.top = 16
          button.contentEdgeInsets.bottom = 16
          button.setTitle(text?.uppercased(), for: .normal)
          button.setTitleColor(.white, for: UIControl.State())
        }
        return button
      }
    }
  }
}
