//
//  WalletBalanceView.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import UIKit

protocol WalletBalanceViewDelegate: AnyObject {
    func didTapAddTransaction()
    func didTapTopUp()
}

class WalletBalanceView: UIView {
  
  private lazy var balanceTitleLabel: UILabel = {
    let view = UILabel()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.text = "Balance"
    view.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    view.textColor = .black
    return view
  }()
  
  private lazy var balanceLabel: UILabel = {
    let view = UILabel()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.text = "$0.00"
    view.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    view.textColor = .black
    return view
  }()
  
  private lazy var buttonsStackView: UIStackView = {
    let view = UIStackView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .horizontal
    view.distribution = .fillEqually
    view.spacing = 16
    return view
  }()
  
  private lazy var addTransactionButton: PrimaryButton = {
    let button = PrimaryButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.configure(title: "Add transaction", icon: UIImage(systemName: "creditcard.circle"))
    return button
  }()
  
  private lazy var topUpButton: PrimaryButton = {
    let button = PrimaryButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.configure(title: "Top Up", icon: UIImage(systemName: "plus.circle"))
    return button
  }()
  
  weak var delegate: WalletBalanceViewDelegate?
  
  init() {
    super.init(frame: .zero)
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func updateBalanceValue(_ value: String) {
    balanceLabel.text = value
  }
  
  private func setupView() {
    addSubview(balanceTitleLabel)
    addSubview(balanceLabel)
    addSubview(buttonsStackView)
    
    buttonsStackView.addArrangedSubview(addTransactionButton)
    buttonsStackView.addArrangedSubview(topUpButton)
    
    addTransactionButton.addTarget(self, action: #selector(didTapAddTransaction), for: .touchUpInside)
    topUpButton.addTarget(self, action: #selector(didTapTopUp), for: .touchUpInside)
    backgroundColor = .systemBackground
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      balanceTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
      balanceTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      balanceTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      
      balanceLabel.topAnchor.constraint(equalTo: balanceTitleLabel.bottomAnchor, constant: 8),
      balanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      balanceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      
      buttonsStackView.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: 16),
      buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
      
      addTransactionButton.heightAnchor.constraint(equalToConstant: 50),
      topUpButton.heightAnchor.constraint(equalToConstant: 50)
    ])
  }
  
  @objc private func didTapAddTransaction() {
    delegate?.didTapAddTransaction()
  }
  
  @objc private func didTapTopUp() {
    delegate?.didTapTopUp()
  }
}
