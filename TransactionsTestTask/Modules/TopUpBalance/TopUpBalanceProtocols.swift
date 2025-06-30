//
//  TopUpBalanceProtocols.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 28.06.2025.
//

import Foundation

protocol TopUpBalanceViewToPresenter {
  func dismiss()
  func addBalance(amount: String)
}

protocol TopUpBalancePresenterToRouter: AnyObject {
  var presenter: TopUpBalanceRouterToPresenter? { get set }
  func dismissScreen()
}

protocol TopUpBalancePresenterToInteractor {
  func addBalance(transaction: Transaction)
}

protocol TopUpBalancePresenterToView: AnyObject {}

protocol TopUpBalanceInteractorToPresenter: AnyObject {
  func transactionAddedSuccessfully()
}

protocol TopUpBalanceRouterToPresenter: AnyObject { }

protocol TopUpBalanceInteractorOutput: AnyObject {
  func didAddBalance(transaction: Transaction)
}
