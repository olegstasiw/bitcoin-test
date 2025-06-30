//
//  AddTransactionsTests.swift
//  TransactionsTestTaskTests
//
//  Created by Oleg Stasiw on 30.06.2025.
//

import XCTest
@testable import TransactionsTestTask

class AddTransactionsTests: XCTestCase {
  
  var presenter: AddTransactionPresenter!
  var mockViewController: MockAddTransactionViewController!
  var mockRouter: MockAddTransactionRouter!
  var mockInteractor: MockAddTransactionInteractor!
  var mockOutput: MockAddTransactionOutput!
  var interactor: AddTransactionInteractor!
  var router: AddTransactionRouter!
  
  override func setUp() {
    super.setUp()
    mockViewController = MockAddTransactionViewController()
    mockRouter = MockAddTransactionRouter()
    mockInteractor = MockAddTransactionInteractor()
    mockOutput = MockAddTransactionOutput()
    
    presenter = AddTransactionPresenter()
    presenter.viewController = mockViewController
    presenter.router = mockRouter
    presenter.interactor = mockInteractor
    
    interactor = AddTransactionInteractor()
    interactor.presenter = presenter
    interactor.output = mockOutput
    
    router = AddTransactionRouter()
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
  
  func testAddTransactionCreatesTransactionAndCallsInteractor() {
    let amount = 150.0
    let category = TransactionCategory.restaurant
    presenter.addTransaction(amount: amount, category: category)
    XCTAssertTrue(mockInteractor.addTransactionCalled)
    XCTAssertNotNil(mockInteractor.lastTransaction)
    XCTAssertEqual(mockInteractor.lastTransaction?.amount, amount)
    XCTAssertEqual(mockInteractor.lastTransaction?.type, .expense)
    XCTAssertEqual(mockInteractor.lastTransaction?.category, category)
  }
  
  func testCloseButtonTappedCallsRouter() {
    presenter.closeButtonTapped()
    XCTAssertTrue(mockRouter.dismissScreenCalled)
  }
  
  func testTransactionAddedSuccessfullyCallsRouter() {
    presenter.transactionAddedSuccessfully()
    XCTAssertTrue(mockRouter.dismissScreenCalled)
  }
  
  func testAddTransactionCallsOutputAndPresenter() {
    let mockTransaction = createMockTransaction()
    interactor.addTransaction(transaction: mockTransaction)
    XCTAssertTrue(mockOutput.addTransactionCalled)
    XCTAssertEqual(mockOutput.lastTransaction?.amount, mockTransaction.amount)
    XCTAssertEqual(mockOutput.lastTransaction?.type, mockTransaction.type)
    XCTAssertEqual(mockOutput.lastTransaction?.category, mockTransaction.category)
  }
  
  func testAddTransactionWithDifferentTransactionTypesCallsOutput() {
    let expenseTransaction = createMockTransaction(type: .expense, category: .taxi)
    interactor.addTransaction(transaction: expenseTransaction)
    
    XCTAssertTrue(mockOutput.addTransactionCalled)
    XCTAssertEqual(mockOutput.lastTransaction?.type, .expense)
    
    mockOutput.addTransactionCalled = false
    mockOutput.lastTransaction = nil
    let incomeTransaction = createMockTransaction(type: .income, category: .other)
    interactor.addTransaction(transaction: incomeTransaction)
    
    XCTAssertTrue(mockOutput.addTransactionCalled)
    XCTAssertEqual(mockOutput.lastTransaction?.type, .income)
  }
  
  func testCompleteFlowAddTransactionDismissesScreen() {
    presenter.interactor = interactor
    let amount = 200.0
    let category = TransactionCategory.restaurant
    presenter.addTransaction(amount: amount, category: category)
    XCTAssertTrue(mockRouter.dismissScreenCalled)
  }
  
  func testCompleteFlow_CloseButton_DismissesScreen() {
    presenter.closeButtonTapped()
    XCTAssertTrue(mockRouter.dismissScreenCalled)
  }
  
  func testAddTransactionWithDecimalAmountCreatesCorrectTransaction() {
    let amount = 123.45
    let category = TransactionCategory.groceries
    presenter.addTransaction(amount: amount, category: category)
    XCTAssertTrue(mockInteractor.addTransactionCalled)
    XCTAssertEqual(mockInteractor.lastTransaction?.amount, amount)
    XCTAssertEqual(mockInteractor.lastTransaction?.category, category)
  }
  
  private func createMockTransaction(amount: Double = 100.0,
                                     type: TransactionType = .expense,
                                     category: TransactionCategory = .taxi,
                                     date: Date = Date()) -> Transaction {
    return Transaction(amount: amount, type: type, category: category, date: date)
  }
}
