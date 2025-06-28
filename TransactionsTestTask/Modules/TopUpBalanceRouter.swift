//
//  TopUpBalanceRouter.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 28.06.2025.
//

import UIKit

class TopUpBalanceRouter: TopUpBalancePresenterToRouter {
  
  weak var presenter: TopUpBalanceRouterToPresenter?
  
  weak var owner: UIViewController?
  
  func dismissScreen() {
    owner?.dismiss(animated: true, completion: nil)
  }
}
