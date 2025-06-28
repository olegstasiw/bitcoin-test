//
//  WalletProtocols.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import Foundation

protocol WalletViewToPresenter {
  var items: [TransactionGroup] { get set }
  func viewDidLoad()
  func routeToAddTransaction()
  func routeToTopUpBalance()
}

protocol WalletPresenterToRouter: AnyObject {
  var presenter: WalletRouterToPresenter? { get set }
  func showAddTransaction()
  func showTopUpBalance()
}

protocol WalletPresenterToInteractor {
  func setupObservers()
  func addTransaction(transaction: Transaction)
}

protocol WalletPresenterToView: AnyObject {
  func updateTransactions()
  func updateBalance(_ balance: String)
}

protocol WalletInteractorToPresenter: AnyObject {
  func updateTransactions(transactions: [TransactionGroup])
  func updateCurrentBalance(_ balance: Double)
}

protocol WalletRouterToPresenter: AnyObject {
  func addNewTransaction(transaction: Transaction)
}
