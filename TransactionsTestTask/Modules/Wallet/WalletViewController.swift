//
//  WalletViewController.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import UIKit

class WalletViewController: UIViewController {
  
  private lazy var priceView: BitconPriceView = {
    let view = BitconPriceView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

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
    tableView.sectionHeaderTopPadding = 8
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
    view.addSubview(priceView)
    view.addSubview(balanceView)
    view.addSubview(transactionsTableView)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      priceView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      priceView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      priceView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      
      balanceView.topAnchor.constraint(equalTo: priceView.bottomAnchor, constant: 8),
      balanceView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      balanceView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      
      transactionsTableView.topAnchor.constraint(equalTo: balanceView.bottomAnchor, constant: 16),
      transactionsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      transactionsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
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
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    // Check if this is the last cell in the last section
    let lastSection = tableView.numberOfSections - 1
    let lastRow = tableView.numberOfRows(inSection: lastSection) - 1
    
    if indexPath.section == lastSection && indexPath.row == lastRow {
      // This is the last cell, check if we need to load more data
      if let presenter = presenter, presenter.hasMoreData {
        presenter.loadMoreData()
        print("Loading more data for section \(indexPath.section), row \(indexPath.row)")
      }
    }
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
  
  func didTapTopUp() {
    presenter?.routeToTopUpBalance()
  }
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
  
  func updateBalance(_ balance: String) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.balanceView.updateBalanceValue(balance)
    }
  }
}
