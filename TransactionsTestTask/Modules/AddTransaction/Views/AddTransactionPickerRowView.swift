//
//  AddTransactionPickerRowView.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 28.06.2025.
//

import UIKit

class SettingsPickerRowView: UIControl {
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Select Category"
    label.font = UIFont.systemFont(ofSize: 17)
    label.textColor = .label
    label.textAlignment = .left
    return label
  }()
  
  private lazy var valueLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .systemBlue
    label.textAlignment = .right
    return label
  }()
  
  var selectedValue: TransactionCategory = .other {
    didSet {
      updateUI()
    }
  }
  
  var onValueChanged: ((TransactionCategory) -> Void)?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    updateUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    layer.cornerRadius = 12
    backgroundColor = .white
    addTarget(self, action: #selector(showPicker), for: .touchUpInside)
    
    addSubview(titleLabel)
    addSubview(valueLabel)
    NSLayoutConstraint.activate([
      heightAnchor.constraint(equalToConstant: 44),
      
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      
      valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8),
    ])
  }
  
  private func updateUI() {
    valueLabel.text = selectedValue.displayName
  }
  
  @objc private func showPicker() {
    guard let vc = parentViewController else { return }
    
    let alert = UIAlertController(title: "Select Category Type", message: nil, preferredStyle: .actionSheet)
    
    for option in TransactionCategory.allCases {
      alert.addAction(UIAlertAction(title: option.displayName, style: .default, handler: { [weak self] _ in
        self?.selectedValue = option
        self?.onValueChanged?(option)
      }))
    }
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    vc.present(alert, animated: true)
  }
}
