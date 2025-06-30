//
//  TransactionCell.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import UIKit

class TransactionCell: UITableViewCell {
  
  private struct Constants {
    static let amountLabelWidth: CGFloat = 80
    static let horizontalPadding: CGFloat = 16
    static let imageSize: CGFloat = 24
    static let categoryLeadingPadding: CGFloat = 12
    static let categoryTopPadding: CGFloat = 12
    static let categoryTrailingPadding: CGFloat = 8
    static let timeBottomPadding: CGFloat = 12
    static let timeTopPadding: CGFloat = 2
    static let timeTrailingPadding: CGFloat = 8
  }
  
  static let identifier = "TransactionCell"
  
  private lazy var iconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    imageView.tintColor = .systemBlue
    return imageView
  }()
  
  private lazy var categoryLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    label.textColor = .label
    return label
  }()
  
  private lazy var timeLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    label.textColor = .secondaryLabel
    return label
  }()
  
  private lazy var amountLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    label.textAlignment = .right
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    contentView.addSubview(iconImageView)
    contentView.addSubview(categoryLabel)
    contentView.addSubview(timeLabel)
    contentView.addSubview(amountLabel)
    
    selectionStyle = .none
    backgroundColor = .systemBackground
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
      iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      iconImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
      iconImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
      
      categoryLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Constants.categoryLeadingPadding),
      categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.categoryTopPadding),
      categoryLabel.trailingAnchor.constraint(lessThanOrEqualTo: amountLabel.leadingAnchor, constant: -Constants.categoryLeadingPadding),
      
      timeLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
      timeLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: Constants.timeTopPadding),
      timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.timeBottomPadding),
      timeLabel.trailingAnchor.constraint(lessThanOrEqualTo: amountLabel.leadingAnchor, constant: -Constants.timeTrailingPadding),
      
      amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
      amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      amountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.amountLabelWidth),
    ])
  }
  
  func configure(with transaction: Transaction) {
    if let category = transaction.category {
      iconImageView.image = UIImage(systemName: category.icon)
      categoryLabel.text = category.displayName
    } else {
      iconImageView.image = UIImage(systemName: transaction.type == .income ? "plus.circle" : "minus.circle")
      categoryLabel.text = transaction.type == .income ? "Top Up" : "Withdrawal"
    }
    
    let timeFormatter = DateFormatter()
    timeFormatter.timeStyle = .short
    timeLabel.text = timeFormatter.string(from: transaction.date)
    
    let sign = transaction.type == .income ? "+" : "-"
    let formattedAmount = String(format: "%.8f", transaction.amount)
    amountLabel.text = "\(sign) \(formattedAmount) BTC"
    amountLabel.textColor = transaction.type == .income ? .systemGreen : .systemRed
  }
}
