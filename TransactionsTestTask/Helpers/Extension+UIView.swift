//
//  Extension+UIView.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 28.06.2025.
//

import UIKit

extension UIView {
  var parentViewController: UIViewController? {
    var responder: UIResponder? = self
    while let r = responder {
      if let vc = r as? UIViewController {
        return vc
      }
      responder = r.next
    }
    return nil
  }
}
