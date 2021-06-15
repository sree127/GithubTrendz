//
//  Factory.swift
//  ApplePaySwag
//
//  Created by Sreejith Njamelil on 11.06.21.
//

import Foundation

public protocol FactoryMethod {
  /// Type of object that the factory uses to create the result : Eg: LabelType can be title, subtitle etc
  associatedtype ObjectType
  
  /// The object that should be returned: Eg: UILabel, UIStackView etc
  associatedtype ObjectResult
    
  /// Function that needs to be implemented by any type that conforms to FactoryMethod
  static func makeFrom(_ type: ObjectType) -> ObjectResult
}

/// Empty Factory construct
public struct Factory { }
