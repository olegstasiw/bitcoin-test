//
//  AddTransactionAssembly.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import UIKit

class AddTransactionAssembly {
  
  func makeModule(output: AddTransactionInteractorOutput?) -> UIViewController {
    let interactor = AddTransactionInteractor()
    let router = AddTransactionRouter()
    let presenter = AddTransactionPresenter()
    let vc = AddTransactionViewController()

    router.owner = vc
    
    presenter.viewController = vc
    presenter.router = router
    presenter.interactor = interactor
    
    vc.presenter = presenter
    interactor.presenter = presenter
    interactor.output = output
    
    return vc
  }
}
