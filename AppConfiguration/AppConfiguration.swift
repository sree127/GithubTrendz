//
//  AppConfiguration.swift
//
//  Created by Sreejith Njamelil on 11.06.21.
//

import Foundation

public struct AppConfiguration {
  
  fileprivate enum Endpoint {
    case githubAPI
  }
  
  fileprivate static let configuration: [Endpoint: String] = [
    .githubAPI: "https://api.github.com/"
  ]
  
  fileprivate static func configurationValue(endpoint: Endpoint) -> AnyHashable? {
    configuration[endpoint]
  }
  
  public static var githubBaseURL: String {
    configurationValue(endpoint: .githubAPI) as! String // force_cast so that it crashes if url not present
  }
}
