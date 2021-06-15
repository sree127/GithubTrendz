//
//  TrendingReposListViewController.swift
//  GithubFavs
//
//  Created by Sreejith Njamelil on 13.06.21.
//

import UIKit
import RxCocoa
import RxSwift

final class TrendingReposListViewController: UIViewController {
  
  let viewModel: TrendingReposListViewModel
  init(dependencies: TrendingReposListViewModel.Dependencies) {
    self.viewModel = TrendingReposListViewModel(dependencies: dependencies)
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI Components
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.estimatedRowHeight = Layout.cellEstimatedRowHeight
    tableView.separatorStyle = .singleLine
    tableView.showsVerticalScrollIndicator = true
    tableView.backgroundColor = Style.Color.Background.back
    tableView.rowHeight = UITableView.automaticDimension
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()
  
  // MARK: - DataSource
  private let dataSourceRelay: BehaviorRelay<Section> = .init(value: Section(items: []))

  // MARK: - Properties
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    layout()
    setupTableDataSourceBinding()
  }
}

// MARK: - Layout
private extension TrendingReposListViewController {
  
  func layout() {
    setupUI()
    layoutTableView()
    setupTableView()
  }
  
  func setupUI() {
    navigationItem.title = "Trending Swift Repos"
  }
  
  func layoutTableView() {
    tableView.separatorInset = UIEdgeInsets(top: 0, left: Layout.separatorLeftInset, bottom: 0, right: 0)
    tableView.backgroundColor = Style.Color.Background.back
    view.addSubview(tableView)
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

// MARK: - Bindings
private extension TrendingReposListViewController {
  
  func setupTableView() {
    tableView.register(GithubRepoInfoCell.self, forCellReuseIdentifier: "GithubRepoInfoCell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.prefetchDataSource = self
  }

  
  func setupTableDataSourceBinding() {
    viewModel.tableDataSourceDriver
      .do(onNext: dataSourceRelay.accept)
      .drive(onNext: { [weak self] _ in self?.tableView.reloadData() })
      .disposed(by: disposeBag)
  }
  
}

// MARK: - DataSource
extension TrendingReposListViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    dataSourceRelay.value.items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "GithubRepoInfoCell", for: indexPath) as? GithubRepoInfoCell else {
      fatalError("Cannot dequeue cell")
    }
    if let cellViewModel = dataSourceRelay.value.items[indexPath.row] as? RepoInfoCellModel {
      cell.configure(cellViewModel: cellViewModel)
    }
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cellViewModel = dataSourceRelay.value.items[indexPath.row] as? RepoInfoCellModel,
       let ownerName = cellViewModel.authorName,
       let repoName = cellViewModel.repoTitle {
      viewModel.routeToDetails(ownerName: ownerName, repoName: repoName)
    }
  }
}

// MARK: - Prefetching
extension TrendingReposListViewController: UITableViewDataSourcePrefetching {
  
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    let lastIndexPath = IndexPath(row: dataSourceRelay.value.items.count - 1, section: 0)
    if indexPaths.contains(lastIndexPath) {
      viewModel.loadNextPage.onNext(())
    }
  }
}

// MARK: - Layout
extension TrendingReposListViewController {
  enum Layout {
    static let separatorLeftInset: CGFloat = 80
    static let cellEstimatedRowHeight: CGFloat = 80
  }
}
