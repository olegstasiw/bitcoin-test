//
//  AddTransactionInteractor.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import Foundation

class AddTransactionInteractor: AddTransactionPresenterToInteractor {

  weak var presenter: AddTransactionInteractorToPresenter?
  
  weak var output: AddTransactionInteractorOutput?
  
  func addTransaction(transaction: Transaction) {
    output?.addTransaction(transaction: transaction)
    presenter?.transactionAddedSuccessfully()
  }
}
