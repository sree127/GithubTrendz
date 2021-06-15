//
//  NetworkProvider.swift
//
//  Created by Sreejith Njamelil on 11.06.21.
//

import Foundation
import RxSwift
import RxCocoa

/// Contains information about all the various network requests
/// New requests should be added here
protocol NetworkInterface {
  /// Request  for trending repos
  /// - Parameter pageNumber: pageNumber for pagination. Starts with 1
  func requestTrendingRepos(pageNumber: Int) -> Single<SearchReposResponse>
  
  /// Request for author image of a repo
  /// - Parameter url: url of the avatar
  func requestAuthorImage(url: URL) -> Single<UIImage?>
  
  
  /// Request for repo details of a specific repo
  /// - Parameters:
  ///   - ownerName: owner name of the repo
  ///   - repoName: the actual name of the repo
  func requestRepoDetails(ownerName: String, repoName: String) -> Single<RepoDetailsResponse>
}

extension NetworkProvider {
  struct Dependencies {
    let baseURL: String
  }
}

final public class NetworkProvider: NetworkInterface {
  
  private let dependencies: Dependencies
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Properties
  private lazy var urlSession: URLSession = {
    let config = URLSessionConfiguration.ephemeral
    config.requestCachePolicy = .reloadIgnoringLocalCacheData
    config.urlCache = nil
    return URLSession(configuration: config)
  }()
  
  // MARK: - Requests
  func requestTrendingRepos(pageNumber: Int) -> Single<SearchReposResponse> {
    // Get URL request
    guard let request = Factory.Request.makeFrom(
      .getTrendingRepos(
        host: dependencies.baseURL,
        pageNumber: pageNumber
      )
    ) else { return .error(NetworkProviderError.urlNotFound) }
    
    /// Create a url session task
    return urlSession.rx.data(request: request)
      .map { try JSONDecoder().decode(SearchReposResponse.self, from: $0) }
      .take(1)
      .asSingle()
  }
  
  func requestAuthorImage(url:  URL) -> Single<UIImage?> {
    let request = URLRequest(url: url)
    return urlSession.rx.data(request: request)
      .map(UIImage.init)
      .retry(2)
      .take(1)
      .asSingle()
  }
  
  func requestRepoDetails(ownerName: String, repoName: String) -> Single<RepoDetailsResponse> {
    guard let request = Factory.Request.makeFrom(
      .getRepoDetails(
        host: dependencies.baseURL,
        ownerName: ownerName,
        repoName: repoName
      )
    ) else { return .error(NetworkProviderError.urlNotFound) }
    
    return urlSession.rx.data(request: request)
      .map { try JSONDecoder().decode(RepoDetailsResponse.self, from: $0) }
      .take(1)
      .asSingle()
  }
}

enum NetworkProviderError: Error {
  case urlNotFound
}
