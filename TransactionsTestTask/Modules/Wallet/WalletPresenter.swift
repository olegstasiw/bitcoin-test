//
//  WalletPresenter.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import Foundation
import Combine

class WalletPresenter: NSObject, WalletViewToPresenter {
  weak var viewController: WalletPresenterToView?
  
  var router: WalletPresenterToRouter? {
    willSet {
      newValue?.presenter = self
    }
  }
  
  var interactor: WalletPresenterToInteractor?
  
  var items: [TransactionGroup] = []
  var currentBalance: Double = 0.0
  var hasMoreData: Bool = false
  var currentBitcoinRate: String = ""
  
  lazy var formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, HH:mm"
    formatter.timeZone = TimeZone.current
    return formatter
  }()
  
  func viewDidLoad() {
    interactor?.setupObservers()
    interactor?.loadBitcoinRate()
    interactor?.startTimerToFetchBitcoinRate()
  }
  
  func routeToAddTransaction() {
    router?.showAddTransaction()
  }
  
  func routeToTopUpBalance() {
    router?.showTopUpBalance()
  }
  
  func loadMoreData() {
    interactor?.loadMoreData()
  }
}

extension WalletPresenter: WalletInteractorToPresenter {
  func updateTransactions(transactions: [TransactionGroup]) {
    items = transactions
    viewController?.updateTransactions()
  }
  
  func updateCurrentBalance(_ balance: Double) {
    currentBalance = balance
    let stringBalance = String(balance)
    viewController?.updateBalance(stringBalance)
  }
  
  func updateHasMoreData(_ hasMore: Bool) {
    hasMoreData = hasMore
  }
  
  func updateBitcoinRate(_ rate: BitcoinRate) {
    let price = rate.price
    let doublePrice = Double(price) ?? 0.0
    let formattedPrice = String(format: "%.2f", doublePrice)
    currentBitcoinRate = formattedPrice
    let lastUpdated = formatter.string(from: rate.date)

    viewController?.updateBitcoinRate(formattedPrice, lastUpdated: lastUpdated)
  }
}

extension WalletPresenter: WalletRouterToPresenter {
  func addNewTransaction(transaction: Transaction) {
    interactor?.addTransaction(transaction: transaction)
  }
}
