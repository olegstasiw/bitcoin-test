//
//  WalletMocks.swift
//  TransactionsTestTaskTests
//
//  Created by Oleg Stasiw on 30.06.2025.
//

import Foundation
@testable import TransactionsTestTask

class MockWalletViewController: WalletPresenterToView {
  var updateTransactionsCalled = false
  var updateBalanceCalled = false
  var updateBitcoinRateCalled = false
  var lastBalance: String?
  var lastBitcoinRate: String?
  var lastLastUpdated: String?
  
  func updateTransactions() {
    updateTransactionsCalled = true
  }
  
  func updateBalance(_ balance: String) {
    updateBalanceCalled = true
    lastBalance = balance
  }
  
  func updateBitcoinRate(_ rate: String, lastUpdated: String) {
    updateBitcoinRateCalled = true
    lastBitcoinRate = rate
    lastLastUpdated = lastUpdated
  }
}

class MockWalletRouter: WalletPresenterToRouter {
  var presenter: WalletRouterToPresenter?
  var showAddTransactionCalled = false
  var showTopUpBalanceCalled = false
  
  func showAddTransaction() {
    showAddTransactionCalled = true
  }
  
  func showTopUpBalance() {
    showTopUpBalanceCalled = true
  }
}

class MockWalletInteractor: WalletPresenterToInteractor {
  var presenter: WalletInteractorToPresenter?
  var setupObserversCalled = false
  var addTransactionCalled = false
  var loadMoreDataCalled = false
  var loadBitcoinRateCalled = false
  var startTimerToFetchBitcoinRateCalled = false
  var loadBitcoinRateFromCacheCalled = false
  var lastTransaction: Transaction?
  
  func setupObservers() {
    setupObserversCalled = true
  }
  
  func addTransaction(transaction: Transaction) {
    addTransactionCalled = true
    lastTransaction = transaction
  }
  
  func loadMoreData() {
    loadMoreDataCalled = true
  }
  
  func loadBitcoinRate() {
    loadBitcoinRateCalled = true
  }
  
  func startTimerToFetchBitcoinRate() {
    startTimerToFetchBitcoinRateCalled = true
  }
  
  func loadBitcoinRateFromCache() {
    loadBitcoinRateFromCacheCalled = true
  }
}
