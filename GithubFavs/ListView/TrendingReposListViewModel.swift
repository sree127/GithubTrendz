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
    let imageService: ImageService
  }
}

final class TrendingReposListViewModel: Stepper {
  
  let steps = PublishRelay<Step>()
  private let dependencies: Dependencies
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Properties
  private(set) lazy var tableDataSourceDriver: Driver<Section> = setupDataSourceDriver()
  private lazy var sectionItemsCached = BehaviorRelay<Section>(value: Section(items: []))
  
  lazy var loadNextPage = PublishSubject<Void>()
  
  func setupDataSourceDriver() -> Driver<Section> {
    loadNextPage
      .startWith(())
      .scan(0) { (pageNumber, _) -> Int in
        pageNumber + 1
      }
      .flatMapLatest { [dependencies] pageNumber in
        return dependencies.networkProvider
          .requestTrendingRepos(pageNumber: pageNumber)
          .map { [dependencies] in $0.items.convertToCellModel(imageService: dependencies.imageService) }
          .do(onSuccess: { [weak self] in
            let cachedItems = self?.sectionItemsCached.value.items ?? []
            self?.sectionItemsCached.accept(Section(items: cachedItems + $0))
          })
          .map { [weak self] currentRepoInfoModel -> Section in
            guard let self = self else { return Section(items: []) }
            let cachedItems = self.sectionItemsCached.value.items
            return Section(items: cachedItems)
          }
      }
      .asDriver(onErrorJustReturn: Section(items: []))
  }
  
  func routeToDetails(ownerName: String, repoName: String) {
    steps.accept(AppFlowStep.repoDetails(ownerName: ownerName, repoName: repoName))
  }
}

// MARK: - Helper Extension
extension Array where Iterator.Element == ItemsResponse {
  
  func convertToCellModel(imageService: ImageService) -> [RepoInfoCellModel] {
    map { itemResponse -> RepoInfoCellModel in
      guard let authorURL = URL(string: itemResponse.owner.avatarURL) else {
        return RepoInfoCellModel(
          authorImageDriver: .just(nil),
          repoTitle: itemResponse.name,
          starsCount: itemResponse.stargazersCount,
          forksCount: itemResponse.forksCount,
          authorName: itemResponse.owner.login
        )
      }
      let imageDriver = imageService
        .imageFromURL(authorURL)
        .take(1)
        .asDriver(onErrorJustReturn: nil)
      return RepoInfoCellModel(
        authorImageDriver: imageDriver,
        repoTitle: itemResponse.name,
        starsCount: itemResponse.stargazersCount,
        forksCount: itemResponse.forksCount,
        authorName: itemResponse.owner.login
      )
    }
  }
}
