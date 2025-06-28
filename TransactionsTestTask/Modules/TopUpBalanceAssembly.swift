//
//  TopUpBalanceAssembly.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 28.06.2025.
//

import UIKit

class TopUpBalanceAssembly {
  
  func makeModule(output: TopUpBalanceInteractorOutput?) -> UIViewController {
    let interactor = TopUpBalanceInteractor()
    let router = TopUpBalanceRouter()
    let presenter = TopUpBalancePresenter()
    let vc = TopUpBalanceViewController()

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
