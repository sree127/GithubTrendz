//
//  RepoInfoCellModel.swift
//  GithubFavs
//
//  Created by Sreejith Njamelil on 13.06.21.
//

import Foundation
import RxCocoa

struct RepoInfoCellModel: RowViewModel {
  var authorImageDriver: Driver<UIImage?>
  var repoTitle: String?
  var starsCount: Int
  var followersCount: Int
  var authorName: String?
}

extension RepoInfoCellViewModel {
  struct Dependencies {
    let searchRepoResponse: SearchReposResponse
  }
}

final class RepoInfoCellViewModel {
  
  private let dependencies: Dependencies
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
}
