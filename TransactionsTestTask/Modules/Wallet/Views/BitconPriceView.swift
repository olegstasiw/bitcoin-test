//
//  BitconPriceView.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 28.06.2025.
//

import UIKit

class BitconPriceView: UIView {
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Bitcoin rate in dollars"
    label.font = UIFont.boldSystemFont(ofSize: 12)
    label.textColor = .secondaryLabel
    label.textAlignment = .left
    return label
  }()
  
  private lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Last updated: ..."
    label.font = UIFont.systemFont(ofSize: 12)
    label.textColor = .secondaryLabel
    label.textAlignment = .right
    return label
  }()
  
  private lazy var titleStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [titleLabel, dateLabel])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    return stackView
  }()
  
  private lazy var priceLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "$0.00"
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textColor = .label
    label.textAlignment = .left
    return label
  }()
  
  init() {
    super.init(frame: .zero)
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func updatePrice(_ price: String, lastUpdated: String) {
    priceLabel.text = "$\(price)"
    dateLabel.text = "Last updated: \(lastUpdated)"
  }
  
  private func setupView() {
    addSubview(titleStackView)
    addSubview(priceLabel)

    backgroundColor = .systemBackground
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      titleStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      titleStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      titleStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

      priceLabel.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 8),
      priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
    ])
  }
}

