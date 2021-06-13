//
//  AppFlow.swift
//  GithubFavs
//
//  Created by Sreejith Njamelil on 13.06.21.
//

import Foundation
import RxFlow

enum AppFlowStep: Step {
  case initial
}

final class AppFlow: Flow {
  
  var root: Presentable { navigationController }
  
  private lazy var navigationController = UINavigationController()
  
  private lazy var networkProvider = NetworkProvider(dependencies: .init(baseURL: AppConfiguration.sumUpReceiptURL))
  
  func navigate(to step: Step) -> FlowContributors {
    guard let step = step as? AppFlowStep else {
      return .none
    }
    switch step {
    case .initial:
      return setRepoListView()
    }
  }
  
  func setRepoListView() -> FlowContributors {
    let viewController = TrendingReposListViewController(dependencies: .init(networkProvider: networkProvider))
    
    navigationController.setViewControllers([viewController], animated: false)
    return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController.viewModel))
  }
}
