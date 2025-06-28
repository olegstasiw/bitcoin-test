//
//  WalleteAssembly.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import UIKit

class WalleteAssembly {
  
  func makeModule() -> UIViewController {
    let transactionService = ServicesAssembler.transactionService()
    let bitcoinRateService = ServicesAssembler.bitcoinRateService()
    let interactor = WalletInteractor(transactionService: transactionService,
                                      bitcoinRateService: bitcoinRateService)
    let router = WalletRouter()
    let presenter = WalletPresenter()
    let vc = WalletViewController()

    router.owner = vc
    
    presenter.viewController = vc
    presenter.router = router
    presenter.interactor = interactor
    
    vc.presenter = presenter
    interactor.presenter = presenter
    
    return vc
  }
}
