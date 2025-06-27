//
//  WalletViewController.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import UIKit

class WalletViewController: UIViewController {
  
  private lazy var balanceView: WalletBalanceView = {
    let view = WalletBalanceView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.delegate = self
    return view
  }()
  
  private lazy var transactionsTableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = .clear
    tableView.separatorStyle = .none
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.identifier)
    return tableView
  }()
 
  var presenter: WalletViewToPresenter?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    setupConstraints()
  }
  
  private func setupViews() {
    view.addSubview(balanceView)
    view.addSubview(transactionsTableView)
    
    view.backgroundColor = .mainBackground
    balanceView.layer.cornerRadius = 8
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      balanceView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      balanceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      balanceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      
      transactionsTableView.topAnchor.constraint(equalTo: balanceView.bottomAnchor, constant: 16),
      transactionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      transactionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      transactionsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

extension WalletViewController: WalletPresenterToView {}

extension WalletViewController: WalletBalanceViewDelegate {
  func didTapAddTransaction() {
    print("Add Transaction button tapped")
  }
  
  func didTapTopUp() {
    print("Top Up button tapped")
  }
}

extension WalletViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    guard let items = presenter?.items else {
      return 0
    }
    return items.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let items = presenter?.items else {
      return 0
    }
    return items[section].transactions.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let presenter,
          let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.identifier, for: indexPath) as? TransactionCell else {
      return UITableViewCell()
    }
    let transaction = presenter.items[indexPath.section].transactions[indexPath.row]
    cell.configure(with: transaction)
    return cell
  }
}

extension WalletViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    print("Selected row at \(indexPath)")
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let items = presenter?.items else {
      return nil
    }
    let headerView = TransactionHeaderView()
    headerView.configure(with: items[section].formattedDate)
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
}
