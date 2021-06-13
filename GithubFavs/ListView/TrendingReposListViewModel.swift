//
//  TrendingReposListViewModel.swift
//  GithubFavs
//
//  Created by Sreejith Njamelil on 13.06.21.
//

import Foundation
import RxCocoa
import RxSwift
import RxFlow

extension TrendingReposListViewModel {
  struct Dependencies {
    let networkProvider: NetworkProvider
  }
}

final class TrendingReposListViewModel: Stepper {
  
  let steps = PublishRelay<Step>()
  private let dependencies: Dependencies
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  private(set) lazy var tableDataSourceDriver: Driver<Section> = setupDataSourceDriver()
  
  func setupDataSourceDriver() -> Driver<Section> {
    dependencies.networkProvider
      .requestTrendingRepos()
      .map { [dependencies] in $0.items.convertToCellModel(networkProvider: dependencies.networkProvider) }
      .map(Section.init)
      .asDriver(onErrorJustReturn: Section(items: []))
  }
}

extension Array where Iterator.Element == ItemsResponse {
  
  func convertToCellModel(networkProvider: NetworkProvider) -> [RepoInfoCellModel] {
    return self.map { itemResponse -> RepoInfoCellModel in
      guard let authorURL = URL(string: itemResponse.owner.avatarURL) else {
        return RepoInfoCellModel(
          authorImageDriver: .just(nil),
          repoTitle: itemResponse.name,
          starsCount: itemResponse.stargazersCount,
          followersCount: itemResponse.watchersCount,
          authorName: itemResponse.owner.login
        )
      }
      let imageDriver = networkProvider
        .requestAuthorImage(url: authorURL)
        .asObservable()
        .take(1)
        .asDriver(onErrorJustReturn: nil)
      return RepoInfoCellModel(
        authorImageDriver: imageDriver,
        repoTitle: itemResponse.name,
        starsCount: itemResponse.stargazersCount,
        followersCount: itemResponse.watchersCount,
        authorName: itemResponse.owner.login
      )
    }
  }
}
