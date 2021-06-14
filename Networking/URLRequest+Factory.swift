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
    case getTrendingRepos(host: String, pageNumber: Int)
    case getRepoDetails(host: String, ownerName: String, repoName: String)
  }
  
  static func makeFrom(_ type: OutputType) -> URLRequest? {
    switch type {
    case let .getTrendingRepos(host, pageNumber):
      var component = URLComponents(string: host)
      component?.queryItems = [
        URLQueryItem(name: "q", value: "language:swift"),
        URLQueryItem(name: "sort", value: "stars"),
        URLQueryItem(name: "page", value: "\(pageNumber)")
      ]
      guard let url = component?.url?.appending(["search", "repositories"]) else { return nil }
      var urlRequest = URLRequest(url: url)
      urlRequest.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
      urlRequest.httpMethod = "GET"
      return urlRequest
    case let .getRepoDetails(host, ownerName, repoName):
      guard let url = URL(string: host)?
              .appending(["repos"])
              .appending(["\(ownerName)/\(repoName)"]) else { return nil }
      var urlRequest = URLRequest(url: url)
      urlRequest.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
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
