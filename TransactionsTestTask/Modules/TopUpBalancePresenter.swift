//
//  TopUpBalancePresenter.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 28.06.2025.
//

import Foundation

class TopUpBalancePresenter: NSObject, TopUpBalanceViewToPresenter {
  weak var viewController: TopUpBalancePresenterToView?
  
  var router: TopUpBalancePresenterToRouter? {
    willSet {
      newValue?.presenter = self
    }
  }
  
  var interactor: TopUpBalancePresenterToInteractor?
  
  func dismiss() {
    router?.dismissScreen()
  }
  
  func addBalance(amount: String) {
    guard let amount = Double(amount), amount > 0 else {
      return
    }
    let transaction = Transaction(amount: amount, type: .income)
      
    interactor?.addBalance(transaction: transaction)
  }
}

extension TopUpBalancePresenter: TopUpBalanceInteractorToPresenter {
  func transactionAddedSuccessfully() {
    router?.dismissScreen()
  }
}

extension TopUpBalancePresenter: TopUpBalanceRouterToPresenter {}
