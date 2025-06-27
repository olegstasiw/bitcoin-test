//
//  WalletRouter.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import UIKit

class WalletRouter {
  
  weak var presenter: WalletRouterToPresenter?
  
  weak var owner: UIViewController?
}

extension WalletRouter: WalletPresenterToRouter {}
