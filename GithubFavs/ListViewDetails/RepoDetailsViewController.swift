//
//  RepoDetailsViewController.swift
//  GithubFavs
//
//  Created by Sreejith Njamelil on 14.06.21.
//

import Foundation
import RxCocoa
import RxSwift

final class RepoDetailsViewController: UIViewController {
  
  let viewModel: RepoDetailsViewModel
  init(dependencies: RepoDetailsViewModel.Dependencies) {
    self.viewModel = RepoDetailsViewModel(dependencies: dependencies)
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI Components
  private lazy var mainStack = Factory.Stack.makeFrom(.vertical(alignment: .fill, distribution: .fill, spacing: Layout.stackSpacing))
  
  private lazy var organizationHeaderStack = Factory.Stack.makeFrom(.horizontal(alignment: .fill, distribution: .fill, spacing: Layout.stackSpacing))
  private lazy var authorImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = Layout.imageViewCornerRadius
    imageView.clipsToBounds = true
    return imageView
  }()
  private lazy var orgNameLabel = Factory.Label.Generic.makeFrom(.subtitle(text: nil))
  private lazy var repoTitleLabel = Factory.Label.Generic.makeFrom(.title(text: nil))
  private lazy var starsLabel = Factory.Label.Generic.makeFrom(.subtitle(text: nil))
  private lazy var followersLabel = Factory.Label.Generic.makeFrom(.subtitle(text: nil))
  private lazy var descriptionLabel = Factory.Label.Generic.makeFrom(.subtitle(text: nil))
  
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    layout()
    bindViewModel()
  }
}

// MARK: - Layout
private extension RepoDetailsViewController {
  
  func layout() {
    view.backgroundColor = Style.Color.Background.back
    
    layoutHeaderStack()
    layoutMainStack()
  }
  
  func layoutHeaderStack() {
    organizationHeaderStack.addArrangedSubview(authorImageView, constraints: [
      authorImageView.heightAnchor.constraint(equalToConstant: Layout.imageViewHeight),
      authorImageView.widthAnchor.constraint(equalTo: authorImageView.heightAnchor)
    ])
    organizationHeaderStack.addArrangedSubview(orgNameLabel)
  }
  
  func layoutMainStack() {
    [organizationHeaderStack, repoTitleLabel, starsLabel, starsLabel, followersLabel, descriptionLabel].forEach { mainStack.addArrangedSubview($0) }
    
    view.addSubview(mainStack)
    NSLayoutConstraint.activate([
      mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.stackSpacing),
      mainStack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: Layout.stackSpacing),
      mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.stackSpacing)
    ])
  }
}

// MARK: - Binding
private extension RepoDetailsViewController {
  
  func bindViewModel() {
    viewModel.titleDriver
      .drive(repoTitleLabel.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.starsCountDriver
      .drive(starsLabel.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.imageURLDriver
      .drive(authorImageView.rx.image)
      .disposed(by: disposeBag)
    
    viewModel.ownerNameDriver
      .drive(orgNameLabel.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.followersCountDriver
      .drive(followersLabel.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.descriptionDriver
      .drive(descriptionLabel.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.titleDriver
      .drive(navigationItem.rx.title)
      .disposed(by: disposeBag)
  }
}

// MARK: - Constant
private extension RepoDetailsViewController {
  enum Layout {
    static let stackSpacing: CGFloat = 16
    static let imageViewCornerRadius: CGFloat = 8
    static let imageViewHeight: CGFloat = 40
  }
}
