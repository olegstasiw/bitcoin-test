//
//  TransactionCell.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import UIKit

class TransactionCell: UITableViewCell {
  
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
      iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      iconImageView.widthAnchor.constraint(equalToConstant: 24),
      iconImageView.heightAnchor.constraint(equalToConstant: 24),
      
      categoryLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
      categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
      categoryLabel.trailingAnchor.constraint(lessThanOrEqualTo: amountLabel.leadingAnchor, constant: -8),
      
      timeLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
      timeLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 2),
      timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
      timeLabel.trailingAnchor.constraint(lessThanOrEqualTo: amountLabel.leadingAnchor, constant: -8),
      
      amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      amountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 80)
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
