//
//  WalletRouter.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import UIKit

class WalletRouter: WalletPresenterToRouter {
  
  weak var presenter: WalletRouterToPresenter?
  
  weak var owner: UIViewController?
  
  func showAddTransaction() {
    let assemly = AddTransactionAssembly()
    let viewController = assemly.makeModule(output: self)
    owner?.present(viewController, animated: true)
  }
  
  func showTopUpBalance() {
    let assembly = TopUpBalanceAssembly()
    let viewController = assembly.makeModule(output: self)
    viewController.modalPresentationStyle = .overFullScreen
    viewController.modalTransitionStyle = .crossDissolve
    owner?.present(viewController, animated: true)
  }
}

extension WalletRouter: AddTransactionInteractorOutput {
  func addTransaction(transaction: Transaction) {
    presenter?.addNewTransaction(transaction: transaction)
  }
}

extension WalletRouter: TopUpBalanceInteractorOutput {
  func didAddBalance(transaction: Transaction) {
    presenter?.addNewTransaction(transaction: transaction)
  }
}
