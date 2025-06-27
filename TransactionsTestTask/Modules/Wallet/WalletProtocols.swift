//
//  WalletProtocols.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import Foundation

protocol WalletViewToPresenter {
  var items: [TransactionGroup] { get set }
}

protocol WalletPresenterToRouter: AnyObject {
  var presenter: WalletRouterToPresenter? { get set }
}

protocol WalletPresenterToInteractor {}

protocol WalletPresenterToView: AnyObject {}

protocol WalletInteractorToPresenter: AnyObject {}

protocol WalletRouterToPresenter: AnyObject {}
