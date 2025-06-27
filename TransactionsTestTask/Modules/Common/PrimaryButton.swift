//
//  PrimaryButton.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import UIKit

class PrimaryButton: UIButton {
  
  init() {
    super.init(frame: .zero)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    var buttonConfiguration = UIButton.Configuration.filled()
    buttonConfiguration.baseForegroundColor = .white
    buttonConfiguration.baseBackgroundColor = .systemBlue
    buttonConfiguration.cornerStyle = .medium
    buttonConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8)
    self.configuration = buttonConfiguration
  }
  
  func configure(title: String, icon: UIImage? = nil) {
    self.configuration?.title = title
    if let icon = icon {
      self.configuration?.image = icon
      self.configuration?.imagePadding = 8
      self.configuration?.imagePlacement = .leading
    }
  }
}
