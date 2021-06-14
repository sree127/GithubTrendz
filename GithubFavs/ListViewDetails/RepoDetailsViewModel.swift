//
//  RepoDetailsViewModel.swift
//  GithubFavs
//
//  Created by Sreejith Njamelil on 14.06.21.
//

import Foundation
import RxSwift
import RxFlow
import RxCocoa

extension RepoDetailsViewModel {
  struct Dependencies {
    let ownerName: String
    let repoName: String
    let networkProvider: NetworkProvider
  }
}

final class RepoDetailsViewModel: Stepper {
  
  let steps = PublishRelay<Step>()
  private let dependencies: Dependencies
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  private let disposeBag = DisposeBag()
  private lazy var repoDetailsRelay = PublishRelay<RepoDetailsResponse>()
  
  private lazy var repoDetailsSingle: Observable<RepoDetailsResponse> = {
    dependencies.networkProvider
      .requestRepoDetails(ownerName: dependencies.ownerName, repoName: dependencies.repoName)
      .asObservable()
      .take(1)
      .share(replay: 1)
  }()
  
  lazy var titleDriver: Driver<String?> = {
    repoDetailsSingle
      .map { $0.name }
      .asDriver(onErrorJustReturn: "-")
  }()
  
  lazy var starsCountDriver: Driver<String?> = {
    repoDetailsSingle
      .map { "⭐️: \($0.stargazersCount)" }
      .asDriver(onErrorJustReturn: "-")
  }()
  
  lazy var followersCountDriver: Driver<String?> = {
    repoDetailsSingle
      .map { "🙌: \($0.watchersCount)" }
      .asDriver(onErrorJustReturn: "-")
  }()
  
  lazy var descriptionDriver: Driver<String?> = {
    repoDetailsSingle
      .map { "📝: \($0.welcomeDescription)" }
      .asDriver(onErrorJustReturn: "-")
  }()
  
  lazy var ownerNameDriver: Driver<String?> = {
    repoDetailsSingle
      .map { $0.owner.login }
      .asDriver(onErrorJustReturn: "-")
  }()
  
  lazy var imageURLDriver: Driver<UIImage?> = {
    repoDetailsSingle
      .map { URL(string: $0.owner.avatarURL) }
      .flatMapLatest { [dependencies] url -> Observable<UIImage?> in
        guard let url = url else { return .empty() }
        return dependencies.networkProvider
          .requestAuthorImage(url: url)
          .asObservable()
          .take(1)
      }
      .asDriver(onErrorJustReturn: nil)
  }()
}
