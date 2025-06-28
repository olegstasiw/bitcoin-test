//
//  AddTransactionRouter.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import UIKit

class AddTransactionRouter: AddTransactionPresenterToRouter {
  
  weak var presenter: AddTransactionRouterToPresenter?
  
  weak var owner: UIViewController?
  
  func dismissScreen() {
    owner?.dismiss(animated: true, completion: nil)
  }
}
