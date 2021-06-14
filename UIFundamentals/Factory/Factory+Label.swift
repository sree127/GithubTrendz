//
//  Factory+Label.swift
//  ApplePaySwag
//
//  Created by Sreejith Njamelil on 11.06.21.
//  Copyright © 2021 Razeware LLC. All rights reserved.
//

import UIKit

public extension Factory {
  
  enum Label {
    
    struct Generic: FactoryMethod {
      
      enum LabelType {
        case title(text: String? = nil, alignment: NSTextAlignment = .left)
        case subtitle(text: String? = nil, alignment: NSTextAlignment = .left)
      }
      
      static func makeFrom(_ type: LabelType) -> UILabel {
        let label = UILabel()
        switch type {
        case let .title(text, alignment):
          label.font = .preferredFont(forTextStyle: .callout)
          label.text = text
          label.textAlignment = alignment
          label.numberOfLines = 0
          label.textColor = .systemGray
        case let.subtitle(text, alignment):
          label.font = .preferredFont(forTextStyle: .subheadline)
          label.text = text
          label.textAlignment = alignment
          label.numberOfLines = 0
          label.textColor = .systemGray
        }
        return label
      }
    }
  }
}
