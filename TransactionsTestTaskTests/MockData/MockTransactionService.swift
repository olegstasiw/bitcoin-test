//
//  MockTransactionService.swift
//  TransactionsTestTaskTests
//
//  Created by Oleg Stasiw on 30.06.2025.
//

import Foundation
@testable import TransactionsTestTask

class MockTransactionService: TransactionService {
  var transactionsPublisher: Published<[TransactionGroup]>.Publisher {
    return $transactions
  }
  
  var currentBalancePublisher: Published<Double>.Publisher {
    return $currentBalance
  }
  
  var hasMoreDataPublisher: Published<Bool>.Publisher {
    return $hasMoreData
  }
  
  @Published var transactions: [TransactionGroup] = []
  @Published var currentBalance: Double = 0
  @Published var hasMoreData: Bool = false
  
  var addTransactionCalled = false
  var loadMoreDataCalled = false
  var lastTransaction: Transaction?
  
  func addTransaction(transaction: Transaction) {
    addTransactionCalled = true
    lastTransaction = transaction
    transactions = [TransactionGroup(date: Date(), transactions: [transaction])]
  }
  
  func loadMoreData() {
    loadMoreDataCalled = true
  }
}
