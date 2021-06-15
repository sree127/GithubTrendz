//
//  AppFlow.swift
//  GithubFavs
//
//  Created by Sreejith Njamelil on 13.06.21.
//

import Foundation
import RxFlow

/// Class which handles all the navigation logic within the app
/// Steppers, such as *ViewModel emits a step which is then processed here

final class AppFlow: Flow {
  
  var root: Presentable { navigationController }
  
  // MARK: - Properties
  private lazy var navigationController = UINavigationController()
  private lazy var networkProvider = NetworkProvider(dependencies: .init(baseURL: AppConfiguration.sumUpReceiptURL))
  private lazy var imageService = ImageService(dependencies: .init(networkProvider: networkProvider))
  
  // MARK: - Main Navigate
  func navigate(to step: Step) -> FlowContributors {
    guard let step = step as? AppFlowStep else {
      return .none
    }
    switch step {
    case .initial:
      return setRepoListView()
    case let .repoDetails(ownerName, repoName):
      return navigateToRepoDetails(ownerName: ownerName, repoName: repoName)
    }
  }
  
  // MARK: - Navigation
  func setRepoListView() -> FlowContributors {
    let viewController = TrendingReposListViewController(
      dependencies: .init(
        networkProvider: networkProvider,
        imageService: imageService
      )
    )
    
    navigationController.setViewControllers([viewController], animated: false)
    return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController.viewModel))
  }
  
  func navigateToRepoDetails(ownerName: String, repoName: String) -> FlowContributors {
    let viewController = RepoDetailsViewController(
      dependencies: .init(
        ownerName: ownerName,
        repoName: repoName,
        networkProvider: networkProvider
      )
    )
    
    navigationController.pushViewController(viewController, animated: true)
    navigationController.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem()
    return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController.viewModel))
  }
}
