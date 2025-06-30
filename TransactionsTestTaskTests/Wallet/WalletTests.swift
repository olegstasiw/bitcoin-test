//
//  WalletTests.swift
//  TransactionsTestTaskTests
//
//  Created by Oleg Stasiw on 30.06.2025.
//

import XCTest
@testable import TransactionsTestTask

class WalletTests: XCTestCase {
  
  var presenter: WalletPresenter!
  var mockViewController: MockWalletViewController!
  var mockRouter: MockWalletRouter!
  var mockInteractor: MockWalletInteractor!
  var mockTransactionService: MockTransactionService!
  var mockBitcoinRateService: MockBitcoinRateService!
  var interactor: WalletInteractor!
  var router: WalletRouter!
  
  override func setUp() {
    super.setUp()
    mockViewController = MockWalletViewController()
    mockRouter = MockWalletRouter()
    mockInteractor = MockWalletInteractor()
    mockTransactionService = MockTransactionService()
    mockBitcoinRateService = MockBitcoinRateService()
    
    presenter = WalletPresenter()
    presenter.viewController = mockViewController
    presenter.router = mockRouter
    presenter.interactor = mockInteractor
    
    interactor = WalletInteractor(
      transactionService: mockTransactionService,
      bitcoinRateService: mockBitcoinRateService
    )
    interactor.presenter = presenter
    
    router = WalletRouter()
    router.presenter = presenter
  }
  
  override func tearDown() {
    presenter = nil
    mockViewController = nil
    mockRouter = nil
    mockInteractor = nil
    mockTransactionService = nil
    mockBitcoinRateService = nil
    interactor = nil
    router = nil
    super.tearDown()
  }
  
  func testViewDidLoadCallsInteractorMethods() {
    presenter.viewDidLoad()
    
    XCTAssertTrue(mockInteractor.setupObserversCalled)
    XCTAssertTrue(mockInteractor.loadBitcoinRateFromCacheCalled)
    XCTAssertTrue(mockInteractor.loadBitcoinRateCalled)
    XCTAssertTrue(mockInteractor.startTimerToFetchBitcoinRateCalled)
  }
  
  func testRouteToAddTransactionCallsRouter() {
    presenter.routeToAddTransaction()
    
    XCTAssertTrue(mockRouter.showAddTransactionCalled)
  }
  
  func testRouteToTopUpBalanceCallsRouter() {
    presenter.routeToTopUpBalance()
    
    XCTAssertTrue(mockRouter.showTopUpBalanceCalled)
  }
  
  func testLoadMoreDataCallsInteractor() {
    presenter.loadMoreData()
    
    XCTAssertTrue(mockInteractor.loadMoreDataCalled)
  }
  
  func testUpdateTransactionsUpdatesItemsAndCallsViewController() {
    let mockTransactions = [
      createMockTransactionGroup(transactions: [createMockTransaction()])
    ]
    
    presenter.updateTransactions(transactions: mockTransactions)
    
    XCTAssertEqual(presenter.items.count, 1)
    XCTAssertTrue(mockViewController.updateTransactionsCalled)
  }
  
  func testUpdateCurrentBalanceUpdatesBalanceAndCallsViewController() {
    let expectedBalance = 1500.0
    
    presenter.updateCurrentBalance(expectedBalance)
    
    XCTAssertEqual(presenter.currentBalance, expectedBalance)
    XCTAssertTrue(mockViewController.updateBalanceCalled)
    XCTAssertEqual(mockViewController.lastBalance, "1500.0")
  }
  
  func testUpdateHasMoreDataUpdatesHasMoreData() {
    let expectedHasMore = true
    
    presenter.updateHasMoreData(expectedHasMore)
    
    XCTAssertEqual(presenter.hasMoreData, expectedHasMore)
  }
  
  func testUpdateBitcoinRateUpdatesRateAndCallsViewController() {
    let mockRate = createMockBitcoinRate(price: "45000.50")
    
    presenter.updateBitcoinRate(mockRate)
    
    XCTAssertEqual(presenter.currentBitcoinRate, "45000.50")
    XCTAssertTrue(mockViewController.updateBitcoinRateCalled)
    XCTAssertEqual(mockViewController.lastBitcoinRate, "45000.50")
    XCTAssertNotNil(mockViewController.lastLastUpdated)
  }
  
  func testAddNewTransactionCallsInteractor() {
    let mockTransaction = createMockTransaction()
    
    presenter.addNewTransaction(transaction: mockTransaction)
    
    XCTAssertTrue(mockInteractor.addTransactionCalled)
    XCTAssertEqual(mockInteractor.lastTransaction?.amount, mockTransaction.amount)
    XCTAssertEqual(mockInteractor.lastTransaction?.type, mockTransaction.type)
  }
  
  func testAddTransactionCallsTransactionService() {
    let mockTransaction = createMockTransaction()
    
    interactor.addTransaction(transaction: mockTransaction)
    
    XCTAssertTrue(mockTransactionService.addTransactionCalled)
    XCTAssertEqual(mockTransactionService.lastTransaction?.amount, mockTransaction.amount)
  }
  
  func testLoadMoreDataCallsTransactionService() {
    interactor.loadMoreData()
    
    XCTAssertTrue(mockTransactionService.loadMoreDataCalled)
  }
  
  func testLoadBitcoinRateSuccessCallsPresenter() {
    mockBitcoinRateService.shouldReturnSuccess = true
    
    interactor.loadBitcoinRate()
    XCTAssertTrue(mockBitcoinRateService.fetchCurrentBTCPriceCalled)
  }
  
  func testLoadBitcoinRateFromCacheWithCachedRateCallsPresenter() {
    let mockRate = createMockBitcoinRate()
    mockBitcoinRateService.mockBitcoinRate = mockRate
    
    interactor.loadBitcoinRateFromCache()
    
    XCTAssertTrue(mockBitcoinRateService.getCachedBitcoinRateCalled)
    XCTAssertEqual(presenter.currentBitcoinRate, "50000.00")
  }
  
  func testLoadBitcoinRateFromCacheWithoutCachedRateDoesNotCallPresenter() {
    mockBitcoinRateService.mockBitcoinRate = nil
    interactor.loadBitcoinRateFromCache()
    XCTAssertTrue(mockBitcoinRateService.getCachedBitcoinRateCalled)
    XCTAssertEqual(presenter.currentBitcoinRate, "")
  }
  
  func testAddTransactionFromAddTransactionCallsPresenter() {
    let mockTransaction = createMockTransaction()
    router.addTransaction(transaction: mockTransaction)
    
    XCTAssertTrue(mockInteractor.addTransactionCalled)
    XCTAssertEqual(mockInteractor.lastTransaction?.amount, mockTransaction.amount)
  }
  
  func testDidAddBalanceFromTopUpBalanceCallsPresenter() {
    let mockTransaction = createMockTransaction()
    router.didAddBalance(transaction: mockTransaction)
    
    XCTAssertTrue(mockInteractor.addTransactionCalled)
    XCTAssertEqual(mockInteractor.lastTransaction?.amount, mockTransaction.amount)
  }
  
  func testBitcoinRateFlowUpdatesUI() {
    let mockRate = createMockBitcoinRate(price: "60000.00")
    presenter.updateBitcoinRate(mockRate)
    
    XCTAssertEqual(presenter.currentBitcoinRate, "60000.00")
    XCTAssertTrue(mockViewController.updateBitcoinRateCalled)
    XCTAssertEqual(mockViewController.lastBitcoinRate, "60000.00")
  }
  
  func testUpdateBitcoinRateWithInvalidPriceHandlesGracefully() {
    let mockRate = BitcoinRate(price: "invalid", date: Date())
    presenter.updateBitcoinRate(mockRate)
    XCTAssertEqual(presenter.currentBitcoinRate, "0.00")
  }
  
  func testUpdateBitcoinRateWithZeroPriceHandlesGracefully() {
    let mockRate = BitcoinRate(price: "0", date: Date())
    presenter.updateBitcoinRate(mockRate)
    XCTAssertEqual(presenter.currentBitcoinRate, "0.00")
  }
  
  func testUpdateBitcoinRateWithLargePriceFormatsCorrectly() {
    let mockRate = BitcoinRate(price: "123456.789", date: Date())
    presenter.updateBitcoinRate(mockRate)
    XCTAssertEqual(presenter.currentBitcoinRate, "123456.79")
  }
  
  private func createMockTransaction(amount: Double = 100.0,
                                     type: TransactionType = .income,
                                     category: TransactionCategory? = .some(.taxi),
                                     date: Date = Date()) -> Transaction {
    return Transaction(amount: amount, type: type, category: category, date: date)
  }
  
  private func createMockTransactionGroup(date: Date = Date(),
                                          transactions: [Transaction] = []) -> TransactionGroup {
    return TransactionGroup(date: date, transactions: transactions)
  }
  
  private func createMockBitcoinRate(price: String = "50000.00",
                                     date: Date = Date()) -> BitcoinRate {
    return BitcoinRate(price: price, date: date)
  }
}
