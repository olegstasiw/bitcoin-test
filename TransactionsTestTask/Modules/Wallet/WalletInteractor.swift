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
  
  private var transactionService: TransactionService
  
  init(transactionService: TransactionService) {
    self.transactionService = transactionService
  }
  
  func setupObservers() {
    TransactionService.shared.$transactions
      .receive(on: DispatchQueue.main)
      .sink { [weak self] transactions in
        self?.presenter?.updateTransactions(transactions: transactions)
      }
      .store(in: &cancellables)
    
    TransactionService.shared.$currentBalance
      .receive(on: DispatchQueue.main)
      .sink { [weak self] balance in
        // to do
      }
      .store(in: &cancellables)
  }
}
