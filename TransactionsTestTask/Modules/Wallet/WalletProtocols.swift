//
//  WalletProtocols.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import Foundation

protocol WalletViewToPresenter {
  var items: [TransactionGroup] { get set }
  var hasMoreData: Bool { get set }
  func viewDidLoad()
  func routeToAddTransaction()
  func routeToTopUpBalance()
  func loadMoreData()
}

protocol WalletPresenterToRouter: AnyObject {
  var presenter: WalletRouterToPresenter? { get set }
  func showAddTransaction()
  func showTopUpBalance()
}

protocol WalletPresenterToInteractor {
  func setupObservers()
  func addTransaction(transaction: Transaction)
  func loadMoreData()
  func loadBitcoinRate()
  func startTimerToFetchBitcoinRate()
  func loadBitcoinRateFromCache()
}

protocol WalletPresenterToView: AnyObject {
  func updateTransactions()
  func updateBalance(_ balance: String)
  func updateBitcoinRate(_ rate: String, lastUpdated: String)
}

protocol WalletInteractorToPresenter: AnyObject {
  func updateTransactions(transactions: [TransactionGroup])
  func updateCurrentBalance(_ balance: Double)
  func updateHasMoreData(_ hasMore: Bool)
  func updateBitcoinRate(_ rate: BitcoinRate)
}

protocol WalletRouterToPresenter: AnyObject {
  func addNewTransaction(transaction: Transaction)
}
