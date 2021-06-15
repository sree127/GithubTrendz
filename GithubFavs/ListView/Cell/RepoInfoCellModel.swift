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
  var forksCount: Int
  var authorName: String?
}
