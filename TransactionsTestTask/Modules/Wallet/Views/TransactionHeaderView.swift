//
//  TransactionHeaderView.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import UIKit

class TransactionHeaderView: UIView {
  
  private struct Constants {
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 8
  }
  
  private lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    label.textColor = .secondaryLabel
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    addSubview(dateLabel)
    backgroundColor = .systemBackground
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
      dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
      dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalPadding),
      dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalPadding)
    ])
  }
  
  func configure(with date: String) {
    dateLabel.text = date
  }
}
