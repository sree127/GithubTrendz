//
//  URLRequest+Factory.swift
//  ApplePaySwag
//
//  Created by Sreejith Njamelil on 11.06.21.
//  Copyright © 2021 Razeware LLC. All rights reserved.
//

import Foundation

extension Factory {
  /// Create URL Requests
  struct Request { private init() {} }
}

extension Factory.Request: FactoryMethod {
  
  enum OutputType {
    case getTrendingRepos(host: String)
  }
  
  static func makeFrom(_ type: OutputType) -> URLRequest? {
    switch type {
    case let .getTrendingRepos(host):
      var components = URLComponents(string: host)
      components?.queryItems = [
        URLQueryItem(name: "language", value: "swift"),
        URLQueryItem(name: "sort", value: "stars"),
      ]
      guard let url = components?.url else { return nil }
      var urlRequest = URLRequest(url: url.appending(["receipts/q="]))
      urlRequest.httpMethod = "GET"
      return urlRequest
    }
  }
}

/// Helper extension for appending path components
private extension URL {
  func appending(_ pathComponents: [String]) -> URL {
    return pathComponents.reduce(self, { result, pathComponent in
      return result.appendingPathComponent(pathComponent)
    })
  }
}