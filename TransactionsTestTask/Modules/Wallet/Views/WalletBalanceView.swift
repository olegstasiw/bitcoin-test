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
  
  private struct Constants {
    static let horizontalPadding: CGFloat = 16
    static let balanceTopPadding: CGFloat = 16
    static let labelTopPadding: CGFloat = 8
    static let buttonSpacing: CGFloat = 16
    static let buttonsVerticalPadding: CGFloat = 16
    static let buttonHeight: CGFloat = 50
  }
  
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
    view.spacing = Constants.buttonSpacing
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
      balanceTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.balanceTopPadding),
      balanceTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
      balanceTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
      
      balanceLabel.topAnchor.constraint(equalTo: balanceTitleLabel.bottomAnchor, constant: Constants.labelTopPadding),
      balanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
      balanceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
      
      buttonsStackView.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: Constants.buttonsVerticalPadding),
      buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
      buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
      buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.buttonsVerticalPadding),
      
      addTransactionButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
      topUpButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
    ])
  }
  
  @objc private func didTapAddTransaction() {
    delegate?.didTapAddTransaction()
  }
  
  @objc private func didTapTopUp() {
    delegate?.didTapTopUp()
  }
}
