//
//  WalletInteractor.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import Foundation
import Combine

class WalletInteractor: WalletPresenterToInteractor {

  weak var presenter: WalletInteractorToPresenter?
  private var cancellables = Set<AnyCancellable>()
  private var fetchRateTimer: Timer?
  private var transactionService: TransactionService
  private let bitcoinRateService: BitcoinRateService
  
  init(transactionService: TransactionService,
       bitcoinRateService: BitcoinRateService) {
    self.transactionService = transactionService
    self.bitcoinRateService = bitcoinRateService
  }
  
  deinit {
    fetchRateTimer?.invalidate()
    fetchRateTimer = nil
  }
  
  func setupObservers() {
    transactionService.transactionsPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] transactions in
        self?.presenter?.updateTransactions(transactions: transactions)
      }
      .store(in: &cancellables)
    
    transactionService.currentBalancePublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] balance in
        self?.presenter?.updateCurrentBalance(balance)
      }
      .store(in: &cancellables)
    
    transactionService.hasMoreDataPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] hasMore in
        self?.presenter?.updateHasMoreData(hasMore)
      }
      .store(in: &cancellables)
  }
  
  func addTransaction(transaction: Transaction) {
    transactionService.addTransaction(transaction: transaction)
  }
  
  func loadMoreData() {
    transactionService.loadMoreData()
  }
  
  func loadBitcoinRate() {
    bitcoinRateService.fetchCurrentBTCPrice { [weak self] result in
      switch result {
      case .success(let rate):
        self?.presenter?.updateBitcoinRate(rate)
      case .failure(let error):
        print("Error fetching Bitcoin rate: \(error.localizedDescription)")
      }
    }
  }
  
  func startTimerToFetchBitcoinRate() {
    fetchRateTimer?.invalidate() // Invalidate any existing timer
    fetchRateTimer = nil
    fetchRateTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
      guard let self = self else { return }
      self.loadBitcoinRate()
    }
  }
}
