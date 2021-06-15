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
    
    refreshRepoDetails()
  }
  
  // MARK: - Private properties
  private let disposeBag = DisposeBag()
  private lazy var repoDetailsRelay = PublishRelay<RepoDetailsResponse>()
  private lazy var repoDetailsObservable: Observable<RepoDetailsResponse> = {
    repoDetailsRelay
      .asObservable()
      .share(replay: 1)
  }()
  
  // MARK: - Public properties
  lazy var titleDriver: Driver<String?> = {
    repoDetailsObservable
      .map { $0.name }
      .asDriver(onErrorJustReturn: "-")
  }()
  
  lazy var starsCountDriver: Driver<String?> = {
    repoDetailsObservable
      .map { "⭐️ Stars: \($0.stargazersCount)" }
      .asDriver(onErrorJustReturn: "-")
  }()
  
  lazy var followersCountDriver: Driver<String?> = {
    repoDetailsObservable
      .map { "🍴 Forks: \($0.forksCount)" }
      .asDriver(onErrorJustReturn: "-")
  }()
  
  lazy var descriptionDriver: Driver<String?> = {
    repoDetailsObservable
      .map { "📝: \($0.welcomeDescription)" }
      .asDriver(onErrorJustReturn: "-")
  }()
  
  lazy var ownerNameDriver: Driver<String?> = {
    repoDetailsObservable
      .map { $0.owner.login }
      .asDriver(onErrorJustReturn: "-")
  }()
  
  lazy var imageURLDriver: Driver<UIImage?> = {
    repoDetailsObservable
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
  
  // MARK: - Fetch Repo Details 
  // Function which handles the refreshing of repo details every 10 seconds
  func refreshRepoDetails() {
    Observable.just(())
      .flatMapLatest {
        return Observable<Int>.timer(
          .seconds(0),
          period: .seconds(Constant.refreshTimeInterval),
          scheduler: SerialDispatchQueueScheduler(internalSerialQueueName: "de.githubtrendz.refreshRepo")
        )
      }
      .flatMapLatest { [weak self] _ -> Observable<RepoDetailsResponse> in
        guard let self = self else { return .empty() }
        return self.dependencies.networkProvider
          .requestRepoDetails(
            ownerName: self.dependencies.ownerName,
            repoName: self.dependencies.repoName
          )
          .asObservable()
          .take(1)
      }
      .subscribe(onNext: repoDetailsRelay.accept)
      .disposed(by: disposeBag)
  }
}

// MARK: - Constant
private extension RepoDetailsViewModel {
  enum Constant {
    // Refresh every 10 seconds and request for new data
    static let refreshTimeInterval = 10
  }
}
