//
//  AddBalanceView.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 28.06.2025.
//

import UIKit

protocol AddBalanceViewDelegate: AnyObject {
  func didTapAddButton(with amount: String)
}

class AddBalanceView: UIView {
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Add Balance"
    label.font = UIFont.boldSystemFont(ofSize: 24)
    label.textAlignment = .center
    return label
  }()
  
  private lazy var amountTextField: PrimaryTextField = {
    let textField = PrimaryTextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  private lazy var addButton: PrimaryButton = {
    let button = PrimaryButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    return button
  }()
  
  weak var delegate: AddBalanceViewDelegate?
  
  init() {
    super.init(frame: .zero)
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView() {
    addSubview(titleLabel)
    addSubview(amountTextField)
    addSubview(addButton)
    
    amountTextField.configure(placeholder: "Enter amount", keyboardType: .decimalPad)
    addButton.configure(title: "Add Balance", icon: UIImage(systemName: "plus.circle"))
    
    backgroundColor = .mainBackground
    
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      
      amountTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
      amountTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      amountTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      amountTextField.heightAnchor.constraint(equalToConstant: 50),
      
      addButton.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 16),
      addButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      addButton.heightAnchor.constraint(equalToConstant: 50),
      addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
    ])
  }
  
  @objc private func addButtonTapped() {
    guard let amount = amountTextField.text, !amount.isEmpty else {
      return
    }
    delegate?.didTapAddButton(with: amount)
  }
}
