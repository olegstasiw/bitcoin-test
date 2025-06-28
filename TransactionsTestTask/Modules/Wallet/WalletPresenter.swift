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
  
  func viewDidLoad() {
    interactor?.setupObservers()
  }
  
  func routeToAddTransaction() {
    router?.showAddTransaction()
  }
}

extension WalletPresenter: WalletInteractorToPresenter {
  func updateTransactions(transactions: [TransactionGroup]) {
    items = transactions
    viewController?.updateTransactions()
  }
}

extension WalletPresenter: WalletRouterToPresenter {
  func addNewTransaction(transaction: Transaction) {
    interactor?.addTransaction(transaction: transaction)
  }
}
