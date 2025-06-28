//
//  AddTransactionProtocols.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import Foundation

protocol AddTransactionViewToPresenter {
  func addTransaction(amount: Double, category: TransactionCategory)
  func closeButtonTapped()
}

protocol AddTransactionPresenterToRouter: AnyObject {
  var presenter: AddTransactionRouterToPresenter? { get set }
  func dismissScreen()
}

protocol AddTransactionPresenterToInteractor {
  func addTransaction(transaction: Transaction)
}

protocol AddTransactionPresenterToView: AnyObject {}

protocol AddTransactionInteractorToPresenter: AnyObject {
  func transactionAddedSuccessfully()
}

protocol AddTransactionRouterToPresenter: AnyObject {}

protocol AddTransactionInteractorOutput: AnyObject {
  func addTransaction(transaction: Transaction)
}
