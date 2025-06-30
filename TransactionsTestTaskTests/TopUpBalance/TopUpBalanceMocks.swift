//
//  TopUpBalanceMocks.swift
//  TransactionsTestTaskTests
//
//  Created by Oleg Stasiw on 30.06.2025.
//

import Foundation
@testable import TransactionsTestTask

class MockTopUpBalanceViewController: TopUpBalancePresenterToView {}

class MockTopUpBalanceRouter: TopUpBalancePresenterToRouter {
  var presenter: TopUpBalanceRouterToPresenter?
  var dismissScreenCalled = false
  
  func dismissScreen() {
    dismissScreenCalled = true
  }
}

class MockTopUpBalanceInteractor: TopUpBalancePresenterToInteractor {
  var presenter: TopUpBalanceInteractorToPresenter?
  var addBalanceCalled = false
  var lastTransaction: Transaction?
  
  func addBalance(transaction: Transaction) {
    addBalanceCalled = true
    lastTransaction = transaction
  }
}

class MockTopUpBalanceOutput: TopUpBalanceInteractorOutput {
  var didAddBalanceCalled = false
  var lastTransaction: Transaction?
  
  func didAddBalance(transaction: Transaction) {
    didAddBalanceCalled = true
    lastTransaction = transaction
  }
}
