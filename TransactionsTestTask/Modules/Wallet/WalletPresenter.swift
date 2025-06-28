//
//  WalletPresenter.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import Foundation
import Combine

class WalletPresenter: NSObject, WalletViewToPresenter {
  weak var viewController: WalletPresenterToView?
  
  var router: WalletPresenterToRouter? {
    willSet {
      newValue?.presenter = self
    }
  }
  
  var interactor: WalletPresenterToInteractor?
  
  var items: [TransactionGroup] = []
  var currentBalance: Double = 0.0
  var hasMoreData: Bool = false
  
  func viewDidLoad() {
    interactor?.setupObservers()
  }
  
  func routeToAddTransaction() {
    router?.showAddTransaction()
  }
  
  func routeToTopUpBalance() {
    router?.showTopUpBalance()
  }
  
  func loadMoreData() {
    interactor?.loadMoreData()
  }
}

extension WalletPresenter: WalletInteractorToPresenter {
  func updateTransactions(transactions: [TransactionGroup]) {
    items = transactions
    viewController?.updateTransactions()
  }
  
  func updateCurrentBalance(_ balance: Double) {
    currentBalance = balance
    let stringBalance = String(balance)
    viewController?.updateBalance(stringBalance)
  }
  
  func updateHasMoreData(_ hasMore: Bool) {
    hasMoreData = hasMore
  }
}

extension WalletPresenter: WalletRouterToPresenter {
  func addNewTransaction(transaction: Transaction) {
    interactor?.addTransaction(transaction: transaction)
  }
}
