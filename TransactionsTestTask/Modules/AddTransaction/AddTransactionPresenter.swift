//
//  AddTransactionPresenter.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import Foundation

class AddTransactionPresenter: NSObject, AddTransactionViewToPresenter {
  weak var viewController: AddTransactionPresenterToView?
  
  var router: AddTransactionPresenterToRouter? {
    willSet {
      newValue?.presenter = self
    }
  }
  
  var interactor: AddTransactionPresenterToInteractor?
  
  func addTransaction(amount: Double, category: TransactionCategory) {
    guard amount > 0 else {
      return
    }
    let date = Date()
    let transaction = Transaction(amount: amount, type: .expense, category: category, date: date)
    interactor?.addTransaction(transaction: transaction)
  }
  
  func closeButtonTapped() {
    router?.dismissScreen()
  }
}

extension AddTransactionPresenter: AddTransactionInteractorToPresenter {
  func transactionAddedSuccessfully() {
    router?.dismissScreen()
  }
}

extension AddTransactionPresenter: AddTransactionRouterToPresenter { }
