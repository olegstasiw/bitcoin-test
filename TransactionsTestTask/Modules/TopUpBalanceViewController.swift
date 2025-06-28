//
//  TopUpBalanceViewController.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 28.06.2025.
//

import UIKit

class TopUpBalanceViewController: UIViewController {
  
  private lazy var closeButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    var config = UIButton.Configuration.plain()
    config.image = UIImage(systemName: "xmark")
    config.imagePadding = 8
    config.imagePlacement = .trailing
    config.baseForegroundColor = .black
    button.configuration = config
    button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    return button
  }()
    
  private lazy var addBalanceView: AddBalanceView = {
    let view = AddBalanceView()
    view.delegate = self
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
 
  var presenter: TopUpBalanceViewToPresenter?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupConstraints()
  }
  
  private func setupViews() {
    view.addSubview(addBalanceView)
    view.addSubview(closeButton)
    
    view.backgroundColor = .black.withAlphaComponent(0.35)
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
    
    addBalanceView.layer.cornerRadius = 16
    addBalanceView.layer.masksToBounds = true
    addBalanceView.layer.shadowColor = UIColor.black.cgColor
    addBalanceView.layer.shadowOpacity = 0.2
    addBalanceView.layer.shadowOffset = CGSize(width: 0, height: 2)
    addBalanceView.layer.shadowRadius = 8
    
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      addBalanceView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      addBalanceView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      addBalanceView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      
      closeButton.topAnchor.constraint(equalTo: addBalanceView.topAnchor, constant: 16),
      closeButton.trailingAnchor.constraint(equalTo: addBalanceView.trailingAnchor, constant: -16),
      closeButton.widthAnchor.constraint(equalToConstant: 30),
      closeButton.heightAnchor.constraint(equalToConstant: 30)
    ])
  }
  
  @objc private func dismissView() {
    presenter?.dismiss()
  }
  
  @objc private func closeButtonTapped() {
    presenter?.dismiss()
  }
}

extension TopUpBalanceViewController: TopUpBalancePresenterToView {}


extension TopUpBalanceViewController: AddBalanceViewDelegate {
  func didTapAddButton(with amount: String) {
    presenter?.addBalance(amount: amount)
  }
}
