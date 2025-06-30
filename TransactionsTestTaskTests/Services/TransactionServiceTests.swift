//
//  TransactionServiceTests.swift
//  TransactionsTestTaskTests
//
//  Created by Oleg Stasiw on 30.06.2025.
//

import Foundation
import XCTest
@testable import TransactionsTestTask

final class TransactionServiceTests: XCTestCase {
  
  var mockCoreDataManager: MockCoreDataManager!
  var transactionService: TransactionServiceImpl!
  
  override func setUp() {
    super.setUp()
    mockCoreDataManager = MockCoreDataManager()
    transactionService = TransactionServiceImpl(coreDataManager: mockCoreDataManager)
  }
  
  override func tearDown() {
    transactionService = nil
    mockCoreDataManager = nil
    super.tearDown()
  }
  
  func testCreatingTransaction() {
    let transaction = Transaction(amount: 100.0, type: .expense, category: .electronics, date: Date())
    transactionService.addTransaction(transaction: transaction)
    
    let transactions = transactionService.fetchAllTransactions()
    XCTAssertEqual(transactions.count, 1)
    let firstTransaction = transactions.first
    XCTAssertEqual(firstTransaction?.amount, 100.0)
    XCTAssertEqual(firstTransaction?.type, TransactionType.expense.rawValue)
    XCTAssertEqual(firstTransaction?.category, TransactionCategory.electronics.rawValue)
    XCTAssertEqual(firstTransaction?.date, transaction.date)
  }
  
  func testCreateAndFetchMultipleTransactionsWithPagination() {
    for index in 1...5 {
      let transaction = Transaction(amount: Double(index + 1), type: .expense, category: .electronics, date: Date())
      transactionService.addTransaction(transaction: transaction)
    }
    let transactions = transactionService.fetchTransactionsWithPagination(offset: 0, limit: 2)
    XCTAssertEqual(transactions.count, 2)
  }
  
  func testGetTotalTransactionCount() {
    for index in 1...2 {
      let transaction = Transaction(amount: Double(index + 1), type: .expense, category: .electronics, date: Date())
      transactionService.addTransaction(transaction: transaction)
    }
    let totalCount = transactionService.getTotalTransactionCount()
    XCTAssertEqual(totalCount, 2)
  }
  
  func testGroupTransactionsByDate() {
    let transaction = Transaction(amount: 1, type: .expense, category: .electronics, date: Date())
    let transaction2 = Transaction(amount: 2, type: .expense, category: .electronics, date: Date())
    let transactionsGroups = transactionService.groupTransactionsByDate([transaction, transaction2])
    XCTAssertEqual(transactionsGroups.count, 1)
    XCTAssertEqual(transactionsGroups.first?.transactions.count, 2)
  }
  
  func testCalculateBalance() {
    let transaction1 = Transaction(amount: 100.0, type: .income, category: .other, date: Date())
    let transaction2 = Transaction(amount: 50.0, type: .expense, category: .groceries, date: Date())
    transactionService.addTransaction(transaction: transaction1)
    transactionService.addTransaction(transaction: transaction2)
    let transactions = transactionService.fetchAllTransactions()
    let balance = transactionService.calculateBalance(from: transactions)
    XCTAssertEqual(balance, 50.0)
  }
}
