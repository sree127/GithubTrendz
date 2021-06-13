//
//  Fromatters.swift
//  ApplePaySwag
//
//  Created by Sreejith Njamelil on 12.06.21.
//  Copyright © 2021 Razeware LLC. All rights reserved.
//

import Foundation

public extension NumberFormatter {
  
  struct Formatters {
      
    static let dollarFormatter: NumberFormatter = {
      let dollarFormatter: NumberFormatter = NumberFormatter()
      dollarFormatter.minimumFractionDigits = 2;
      dollarFormatter.maximumFractionDigits = 2;
      return dollarFormatter
    }()
  }
}


