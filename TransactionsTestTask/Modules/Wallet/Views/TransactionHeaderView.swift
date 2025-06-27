//
//  TransactionHeaderView.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import UIKit

class TransactionHeaderView: UIView {
  
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
      dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
    ])
  }
  
  func configure(with date: String) {
    dateLabel.text = date
  }
}
