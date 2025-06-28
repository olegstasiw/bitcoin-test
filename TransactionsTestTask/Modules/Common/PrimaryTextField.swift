//
//  PrimaryTextField.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import UIKit

class PrimaryTextField: UITextField {
  
  let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
  
  init() {
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    self.borderStyle = .roundedRect
    self.backgroundColor = UIColor.systemGray6
    self.font = UIFont.systemFont(ofSize: 16)
    self.textColor = UIColor.label
    self.layer.cornerRadius = 8
    self.layer.masksToBounds = true
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor.systemGray4.cgColor
  }
  
  func configure(placeholder: String, keyboardType: UIKeyboardType = .default) {
    self.placeholder = placeholder
    self.clearButtonMode = .whileEditing
    self.autocorrectionType = .no
    self.spellCheckingType = .no
    self.keyboardType = keyboardType
    self.returnKeyType = .done
  }
  
  override open func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
}
