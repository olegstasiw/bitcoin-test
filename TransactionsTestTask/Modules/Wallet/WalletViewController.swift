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
    setupUI()
    setupConstraints()
    presenter?.viewDidLoad()
  }
  
  private func setupUI() {
    view.backgroundColor = .mainBackground
    view.addSubview(balanceView)
    view.addSubview(transactionsTableView)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      balanceView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      balanceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      balanceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      
      transactionsTableView.topAnchor.constraint(equalTo: balanceView.bottomAnchor, constant: 20),
      transactionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      transactionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      transactionsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

extension WalletViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter?.items.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter?.items[section].transactions.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.identifier, for: indexPath) as? TransactionCell,
          let items = presenter?.items else {
      return UITableViewCell()
    }
    
    let transaction = items[indexPath.section].transactions[indexPath.row]
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

extension WalletViewController: WalletBalanceViewDelegate {
  func didTapAddTransaction() {
    presenter?.routeToAddTransaction()
  }
  
  func didTapTopUp() {}
}

extension WalletViewController: WalletPresenterToView {
  func updateTransactions() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
        UIView.animate(withDuration: 0.3) {
          self.transactionsTableView.reloadData()
        }
    }
  }
}
