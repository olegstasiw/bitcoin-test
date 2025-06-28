//
//  TopUpBalanceInteractor.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 28.06.2025.
//

import Foundation

class TopUpBalanceInteractor: TopUpBalancePresenterToInteractor {

  weak var presenter: TopUpBalanceInteractorToPresenter?
  
  weak var output: TopUpBalanceInteractorOutput?
  
  func addBalance(transaction: Transaction) {
    output?.didAddBalance(transaction: transaction)
    presenter?.transactionAddedSuccessfully()
  }
}
