//
//  AppConfiguration.swift
//  ApplePaySwag
//
//  Created by Sreejith Njamelil on 11.06.21.
//  Copyright © 2021 Razeware LLC. All rights reserved.
//

import Foundation

public struct AppConfiguration {
  
  fileprivate enum Endpoint {
    case searchRepositories
  }
  
  fileprivate static let configuration: [Endpoint: String] = [
    .searchRepositories: "https://api.github.com/search/"
  ]
  
  fileprivate static func configurationValue(endpoint: Endpoint) -> AnyHashable? {
    configuration[endpoint]
  }
    
  public static var sumUpReceiptURL: String {
    configurationValue(endpoint: .searchRepositories) as! String // force_cast so that it crashes if url not present
  }
}
