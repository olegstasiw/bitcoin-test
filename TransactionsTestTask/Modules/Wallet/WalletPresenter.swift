//
//  WalletPresenter.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import Foundation

class WalletPresenter: NSObject, WalletViewToPresenter {
  weak var viewController: WalletPresenterToView?
  
  var router: WalletPresenterToRouter? {
    willSet {
      newValue?.presenter = self
    }
  }
  
  var interactor: WalletPresenterToInteractor?
  
  var items: [TransactionGroup] = TransactionService.shared.generateFakeTransactions()
}

extension WalletPresenter: WalletInteractorToPresenter {
}

extension WalletPresenter: WalletRouterToPresenter { }
