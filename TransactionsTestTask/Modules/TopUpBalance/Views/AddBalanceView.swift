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
  
  private struct Constants {
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 16
    static let buttonHeight: CGFloat = 50
    static let textFieldHeight: CGFloat = 50
    static let spacing: CGFloat = 16
  }
  
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
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalPadding),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
      
      amountTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.spacing),
      amountTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
      amountTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
      amountTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),
      
      addButton.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: Constants.spacing),
      addButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
      addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
      addButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
      addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalPadding)
    ])
  }
  
  @objc private func addButtonTapped() {
    guard let amount = amountTextField.text, !amount.isEmpty else {
      return
    }
    delegate?.didTapAddButton(with: amount)
  }
}
