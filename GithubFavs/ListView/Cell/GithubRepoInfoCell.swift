//
//  GithubRepoInfoCell.swift
//  GithubFavs
//
//  Created by Sreejith Njamelil on 13.06.21.
//

import UIKit
import RxSwift
import RxCocoa

class GithubRepoInfoCell: UITableViewCell {
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI Components
  private lazy var mainStack = Factory.Stack.makeFrom(.horizontal(alignment: .center, distribution: .fill, spacing: Layout.stackSpacing))
  
  private lazy var authorImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = Layout.imageViewCornerRadius
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private lazy var descriptionStack = Factory.Stack.makeFrom(.vertical(alignment: .fill, distribution: .fill, spacing: Layout.stackSpacing))
  private lazy var repoTitleLabel = Factory.Label.Generic.makeFrom(.title(text: nil))
  private lazy var starsLabel = Factory.Label.Generic.makeFrom(.subtitle(text: nil))
  private lazy var followersLabel = Factory.Label.Generic.makeFrom(.subtitle(text: nil))
  private lazy var authorNameLabel = Factory.Label.Generic.makeFrom(.subtitle(text: nil))

  private var disposeBag = DisposeBag()
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    disposeBag = DisposeBag()
  }
}

// MARK: - Layout
private extension GithubRepoInfoCell {
  
  func layout() {
    backgroundColor = Style.Color.Background.back
    accessoryType = .disclosureIndicator
    selectionStyle = .none
    
    layoutDescriptionStack()
    layoutMainStack()
  }
  
  func layoutDescriptionStack() {
    [repoTitleLabel, starsLabel, followersLabel, authorNameLabel].forEach { descriptionStack.addArrangedSubview($0) }
  }
  
  func layoutMainStack() {
    mainStack.addArrangedSubview(authorImageView, constraints: [
      authorImageView.widthAnchor.constraint(equalTo: mainStack.widthAnchor, multiplier: 0.3),
      authorImageView.heightAnchor.constraint(equalTo: authorImageView.widthAnchor)
    ])
    mainStack.addArrangedSubview(descriptionStack)
  
    contentView.addSubview(mainStack)
    NSLayoutConstraint.activate([
      mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.contentPadding),
      mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.contentPadding),
      mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.contentPadding),
      mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layout.contentPadding)
    ])
  }
}

// MARK: - Configure
extension GithubRepoInfoCell {
  
  func configure(cellViewModel: RepoInfoCellModel) {
    repoTitleLabel.text = cellViewModel.repoTitle
    starsLabel.text = "⭐️ \(cellViewModel.starsCount)"
    followersLabel.text = "🙌 \(cellViewModel.followersCount)"
    authorNameLabel.text = "Author: \(cellViewModel.authorName ?? "-")"
    cellViewModel.authorImageDriver
      .drive(authorImageView.rx.image)
      .disposed(by: disposeBag)
  }
}

// MARK: - Constants
private extension GithubRepoInfoCell {
  enum Layout {
    static let stackSpacing: CGFloat = 16
    static let imageViewCornerRadius: CGFloat = 8
    static let contentPadding: CGFloat = 10
  }
}
