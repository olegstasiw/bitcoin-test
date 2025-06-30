//
//  AddTransactionCategoryPicker.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 28.06.2025.
//

import UIKit

protocol AddTransactionCategoryPickerDelegate: AnyObject {
  func didSelectCategory(_ category: TransactionCategory)
}

class AddTransactionCategoryPicker: UIView {
  
  private struct Constants {
    static let titleLabelTopPadding: CGFloat = 16
  }
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Select Category"
    label.font = UIFont.boldSystemFont(ofSize: 24)
    label.textColor = .black
    return label
  }()
  
  private lazy var categoryPicker: SettingsPickerRowView = {
    let picker = SettingsPickerRowView()
    picker.translatesAutoresizingMaskIntoConstraints = false
    return picker
  }()
  
  var selectedCategory: TransactionCategory {
    return categoryPicker.selectedValue
  }
  
  weak var delegate: AddTransactionCategoryPickerDelegate?
  
  init() {
    super.init(frame: .zero)
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    addSubview(titleLabel)
    addSubview(categoryPicker)
    
    backgroundColor = .mainBackground
    categoryPicker.backgroundColor = .white
    categoryPicker.onValueChanged = { [weak self] category in
      self?.delegate?.didSelectCategory(category)
    }
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      
      categoryPicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.titleLabelTopPadding),
      categoryPicker.leadingAnchor.constraint(equalTo: leadingAnchor),
      categoryPicker.trailingAnchor.constraint(equalTo: trailingAnchor),
      categoryPicker.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  func setSelectedCategory(_ category: TransactionCategory) {
    categoryPicker.selectedValue = category
  }
}
