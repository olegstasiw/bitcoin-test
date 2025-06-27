//
//  WalletViewController.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import UIKit

class WalletViewController: UIViewController {
  
  private lazy var balanceView: WalletBalanceView = {
    let view = WalletBalanceView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.delegate = self
    return view
  }()
 
  var presenter: WalletViewToPresenter?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    setupConstraints()
  }
  
  private func setupViews() {
    view.addSubview(balanceView)
    
    view.backgroundColor = .mainBackground
    balanceView.layer.cornerRadius = 8
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      balanceView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      balanceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      balanceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    ])
  }
}

extension WalletViewController: WalletPresenterToView {}

extension WalletViewController: WalletBalanceViewDelegate {
  func didTapAddTransaction() {
    print("Add Transaction button tapped")
  }
  
  func didTapTopUp() {
    print("Top Up button tapped")
  }
}
