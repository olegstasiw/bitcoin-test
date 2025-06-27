//
//  WalletProtocols.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import Foundation

protocol WalletViewToPresenter {}

protocol WalletPresenterToRouter: AnyObject {
  var presenter: WalletRouterToPresenter? { get set }
}

protocol WalletPresenterToInteractor {}

protocol WalletPresenterToView: AnyObject {}

protocol WalletInteractorToPresenter: AnyObject {}

protocol WalletRouterToPresenter: AnyObject {}
