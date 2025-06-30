//
//  TopUpBalanceTests.swift
//  TransactionsTestTaskTests
//
//  Created by Oleg Stasiw on 30.06.2025.
//

import XCTest
@testable import TransactionsTestTask

class TopUpBalanceTests: XCTestCase {
  
  var presenter: TopUpBalancePresenter!
  var mockViewController: MockTopUpBalanceViewController!
  var mockRouter: MockTopUpBalanceRouter!
  var mockInteractor: MockTopUpBalanceInteractor!
  var mockOutput: MockTopUpBalanceOutput!
  var interactor: TopUpBalanceInteractor!
  var router: TopUpBalanceRouter!
  
  override func setUp() {
    super.setUp()
    mockViewController = MockTopUpBalanceViewController()
    mockRouter = MockTopUpBalanceRouter()
    mockInteractor = MockTopUpBalanceInteractor()
    mockOutput = MockTopUpBalanceOutput()
    
    presenter = TopUpBalancePresenter()
    presenter.viewController = mockViewController
    presenter.router = mockRouter
    presenter.interactor = mockInteractor
    
    interactor = TopUpBalanceInteractor()
    interactor.presenter = presenter
    interactor.output = mockOutput
    
    router = TopUpBalanceRouter()
    router.presenter = presenter
  }
  
  override func tearDown() {
    presenter = nil
    mockViewController = nil
    mockRouter = nil
    mockInteractor = nil
    mockOutput = nil
    interactor = nil
    router = nil
    super.tearDown()
  }
  
  func testAddBalanceSuccessfuly() {
    let amount = "150.0"
    presenter.addBalance(amount: amount)
    
    XCTAssertTrue(mockInteractor.addBalanceCalled)
    XCTAssertNotNil(mockInteractor.lastTransaction)
    XCTAssertEqual(mockInteractor.lastTransaction?.amount, 150.0)
    XCTAssertEqual(mockInteractor.lastTransaction?.type, .income)
    XCTAssertNil(mockInteractor.lastTransaction?.category)
  }
  
  func testAddBalanceWithDecimalAmountCreatesCorrectTransaction() {
    let amount = "123.45"
    presenter.addBalance(amount: amount)
    
    XCTAssertTrue(mockInteractor.addBalanceCalled)
    XCTAssertEqual(mockInteractor.lastTransaction?.amount, 123.45)
    XCTAssertEqual(mockInteractor.lastTransaction?.type, .income)
  }
  
  func testAddBalanceWithZeroAmountDoesNotCallInteractor() {
    let amount = "0"
    presenter.addBalance(amount: amount)
    
    XCTAssertFalse(mockInteractor.addBalanceCalled)
    XCTAssertNil(mockInteractor.lastTransaction)
  }
  
  func testAddBalanceWithNegativeAmountDoesNotCallInteractor() {
    let amount = "-50.0"
    presenter.addBalance(amount: amount)
    
    XCTAssertFalse(mockInteractor.addBalanceCalled)
    XCTAssertNil(mockInteractor.lastTransaction)
  }
  
  func testAddBalanceWithInvalidStringDoesNotCallInteractor() {
    let amount = "invalid"
    presenter.addBalance(amount: amount)
    
    XCTAssertFalse(mockInteractor.addBalanceCalled)
    XCTAssertNil(mockInteractor.lastTransaction)
  }
  
  func testAddBalanceWithEmptyStringDoesNotCallInteractor() {
    let amount = ""
    presenter.addBalance(amount: amount)
    
    XCTAssertFalse(mockInteractor.addBalanceCalled)
    XCTAssertNil(mockInteractor.lastTransaction)
  }
  
  func testTransactionAddedSuccessfullyCallsRouter() {
    presenter.transactionAddedSuccessfully()
    
    XCTAssertTrue(mockRouter.dismissScreenCalled)
  }
  
  func testAddBalanceCallsOutputAndPresenter() {
    let mockTransaction = createMockTransaction()
    interactor.addBalance(transaction: mockTransaction)
    
    XCTAssertTrue(mockOutput.didAddBalanceCalled)
    XCTAssertEqual(mockOutput.lastTransaction?.amount, mockTransaction.amount)
    XCTAssertEqual(mockOutput.lastTransaction?.type, mockTransaction.type)
    XCTAssertEqual(mockOutput.lastTransaction?.category, mockTransaction.category)
  }
  
  func testAddBalanceWithIncomeTransactionCallsOutput() {
    let incomeTransaction = createMockTransaction(amount: 500.0, type: .income)
    interactor.addBalance(transaction: incomeTransaction)
    
    XCTAssertTrue(mockOutput.didAddBalanceCalled)
    XCTAssertEqual(mockOutput.lastTransaction?.type, .income)
    XCTAssertEqual(mockOutput.lastTransaction?.amount, 500.0)
  }
  
  func testCompleteFlowAddBalanceDismissesScreen() {
    presenter.interactor = interactor
    let amount = "200.0"
    presenter.addBalance(amount: amount)
    
    XCTAssertTrue(mockRouter.dismissScreenCalled)
  }
  
  func testCompleteFlowDismissesScreen() {
    presenter.dismiss()
    
    XCTAssertTrue(mockRouter.dismissScreenCalled)
  }
  
  func testAddBalanceWithLeadingZerosHandlesCorrectly() {
    let amountWithLeadingZeros = "00150.0"
    presenter.addBalance(amount: amountWithLeadingZeros)
    
    XCTAssertTrue(mockInteractor.addBalanceCalled)
    XCTAssertEqual(mockInteractor.lastTransaction?.amount, 150.0)
  }
  
  private func createMockTransaction(amount: Double = 100.0,
                                     type: TransactionType = .income,
                                     category: TransactionCategory? = nil,
                                     date: Date = Date()) -> Transaction {
    return Transaction(amount: amount, type: type, category: category, date: date)
  }
}
