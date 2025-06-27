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
}

protocol WalletPresenterToRouter: AnyObject {
  var presenter: WalletRouterToPresenter? { get set }
}

protocol WalletPresenterToInteractor {
  func setupObservers()
}

protocol WalletPresenterToView: AnyObject {
  func updateTransactions()
}

protocol WalletInteractorToPresenter: AnyObject {
  func updateTransactions(transactions: [TransactionGroup])
}

protocol WalletRouterToPresenter: AnyObject {}
