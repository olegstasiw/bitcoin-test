//
//  AddTransactionViewController.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import UIKit

class AddTransactionViewController: UIViewController {
  
  private lazy var closeButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    var config = UIButton.Configuration.plain()
    config.image = UIImage(systemName: "xmark")
    config.imagePadding = 8
    config.imagePlacement = .trailing
    config.baseForegroundColor = .black
    button.configuration = config
    button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Add Transaction"
    label.font = UIFont.boldSystemFont(ofSize: 24)
    label.textColor = .black
    return label
  }()
  
  private lazy var addTransactionTextField: PrimaryTextField = {
    let textField = PrimaryTextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  private lazy var categoryPicker: AddTransactionCategoryPicker = {
    let picker = AddTransactionCategoryPicker()
    picker.translatesAutoresizingMaskIntoConstraints = false
    picker.delegate = self
    return picker
  }()
  
  private lazy var addButton: PrimaryButton = {
    let button = PrimaryButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.configure(title: "Add Transaction")
    button.addTarget(self, action: #selector(addTransactionTapped), for: .touchUpInside)
    return button
  }()
  
  var presenter: AddTransactionViewToPresenter?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupConstraints()
  }
  
  private func setupView() {
    view.addSubview(closeButton)
    view.addSubview(titleLabel)
    view.addSubview(addTransactionTextField)
    view.addSubview(categoryPicker)
    view.addSubview(addButton)
    
    view.backgroundColor = .mainBackground
    addTransactionTextField.configure(placeholder: "0",
                                      keyboardType: .decimalPad)
    categoryPicker.setSelectedCategory(.other)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      closeButton.widthAnchor.constraint(equalToConstant: 44),
      closeButton.heightAnchor.constraint(equalToConstant: 44),
      
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
      
      addTransactionTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
      addTransactionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      addTransactionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      addTransactionTextField.heightAnchor.constraint(equalToConstant: 50),
      
      categoryPicker.topAnchor.constraint(equalTo: addTransactionTextField.bottomAnchor, constant: 16),
      categoryPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      categoryPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      
      addButton.topAnchor.constraint(equalTo: categoryPicker.bottomAnchor, constant: 16),
      addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      addButton.heightAnchor.constraint(equalToConstant: 50)
    ])
  }
  
  @objc private func addTransactionTapped() {
    guard let amountSting = addTransactionTextField.text, let double = Double(amountSting) else { return }
    let category = categoryPicker.selectedCategory
    presenter?.addTransaction(amount: double, category: category)
  }
  
  @objc private func closeButtonTapped() {
    presenter?.closeButtonTapped()
  }
}

extension AddTransactionViewController: AddTransactionPresenterToView {}


extension AddTransactionViewController: AddTransactionCategoryPickerDelegate {
  
  func didSelectCategory(_ category: TransactionCategory) {
    print("Selected category: \(category.displayName)")
  }
}
