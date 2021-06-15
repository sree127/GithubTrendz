//
//  Style.swift
//
//  Created by Sreejith Njamelil on 11.06.21.
//

import UIKit

/// Contains All Styling information for UI components
public enum Style {
  
  public enum Color {
    
    // MARK: Constants
    public enum Background {
      
      /// Base background color on the lowest level. E.g.: Background of tableViews
      public static let back = UIColor.from(
        dark: .init(hex: 0x121212),
        light: .init(hex: 0xF6F6F4),
        fallback: .init(hex: 0xF6F6F4))
      
      /// Base background color on second lowest level. E.g.: Background of Cells
      public static let middle = UIColor.from(
        dark: .init(hex: 0x222222),
        light: .init(hex: 0xFFFFFF),
        fallback: .init(hex: 0xFFFFFF))
      
      /// Base background color on third lowest level. E.g.: Background of views on top of cells
      public static let front = UIColor.from(
        dark: .init(hex: 0x333333),
        light: .init(hex: 0xF7F7F7),
        fallback: .init(hex: 0xF7F7F7))
    }
  }
  
}

/// DarkMode/LightMode logic
extension UIColor {
  
  static func from(dark: UIColor, light: UIColor, fallback: UIColor) -> UIColor {
    if #available(iOS 13.0, *) {
      return UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .light {
          return light
        }
        return dark
      }
    } else {
      return fallback
    }
  }
}

/// Hex value to UIColor
extension UIColor {
  convenience init(hex: Int, alpha: CGFloat = 1.0) {
    let r = CGFloat((hex & 0xFF0000) >> 16)/255
    let g = CGFloat((hex & 0xFF00) >> 8)/255
    let b = CGFloat(hex & 0xFF)/255
    self.init(red: r, green: g, blue: b, alpha: alpha)
  }
}
