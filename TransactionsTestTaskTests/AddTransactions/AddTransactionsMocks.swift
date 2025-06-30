//
//  AddTransactionsMocks.swift
//  TransactionsTestTaskTests
//
//  Created by Oleg Stasiw on 30.06.2025.
//

import Foundation
@testable import TransactionsTestTask

class MockAddTransactionViewController: AddTransactionPresenterToView {}

class MockAddTransactionRouter: AddTransactionPresenterToRouter {
  var presenter: AddTransactionRouterToPresenter?
  var dismissScreenCalled = false
  
  func dismissScreen() {
    dismissScreenCalled = true
  }
}

class MockAddTransactionInteractor: AddTransactionPresenterToInteractor {
  var presenter: AddTransactionInteractorToPresenter?
  var addTransactionCalled = false
  var lastTransaction: Transaction?
  
  func addTransaction(transaction: Transaction) {
    addTransactionCalled = true
    lastTransaction = transaction
  }
}

class MockAddTransactionOutput: AddTransactionInteractorOutput {
  var addTransactionCalled = false
  var lastTransaction: Transaction?
  
  func addTransaction(transaction: Transaction) {
    addTransactionCalled = true
    lastTransaction = transaction
  }
}
