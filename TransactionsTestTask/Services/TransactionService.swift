//
//  TransactionService.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import Foundation
import CoreData
import Combine

class TransactionService: ObservableObject {
  
  static let shared = TransactionService()
  private let coreDataManager = CoreDataManager.shared
  
  @Published var transactions: [TransactionGroup] = []
  @Published var currentBalance: Double = 0.0
  
  private var cancellables = Set<AnyCancellable>()
  
  private init() {
    setupObservers()
    loadData()
  }
  
  private func setupObservers() {
    NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave, object: coreDataManager.context)
      .sink { [weak self] _ in
        self?.loadData()
      }
      .store(in: &cancellables)
  }
  
  private func loadData() {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let self = self else { return }
      
      let transactionEntities = self.coreDataManager.fetchAllTransactions()
      let transactions = transactionEntities.map { entity in
        Transaction(
          amount: entity.amount,
          type: TransactionType(rawValue: entity.type ?? "expense") ?? .expense,
          category: entity.category.flatMap { TransactionCategory(rawValue: $0) },
          date: entity.date ?? Date(),
          description: entity.transactionDescription
        )
      }
      
      let groupedTransactions = self.groupTransactionsByDate(transactions)
      let balance = self.calculateBalance(from: transactionEntities)
      
      DispatchQueue.main.async {
        self.transactions = groupedTransactions
        self.currentBalance = balance
      }
    }
  }
  
  private func calculateBalance(from entities: [TransactionEntity]) -> Double {
    var balance: Double = 0.0
    
    for entity in entities {
      let type = TransactionType(rawValue: entity.type ?? "expense") ?? .expense
      if type == .income {
        balance += entity.amount
      } else {
        balance -= entity.amount
      }
    }
    
    return balance
  }
  
  func addTransaction(transaction: Transaction) {
    addTransaction(amount: transaction.amount,
                   type: transaction.type,
                   category: transaction.category,
                   date: transaction.date,
                   description: transaction.description)
  }
  
  func addTransaction(amount: Double, type: TransactionType, category: TransactionCategory? = nil, date: Date = Date(), description: String? = nil) {
    coreDataManager.createTransaction(
      amount: amount,
      type: type,
      category: category,
      date: date,
      description: description
    )
  }
  
  func deleteTransaction(_ transaction: Transaction) {
    let transactionEntities = coreDataManager.fetchAllTransactions()
    if let entityToDelete = transactionEntities.first(where: { entity in
      entity.amount == transaction.amount &&
      entity.type == transaction.type.rawValue &&
      entity.date == transaction.date
    }) {
      coreDataManager.deleteTransaction(entityToDelete)
    }
  }
  
  func clearAllTransactions() {
    coreDataManager.deleteAllTransactions()
  }
  
  // MARK: - Helper Methods
  
  private func groupTransactionsByDate(_ transactions: [Transaction]) -> [TransactionGroup] {
    let calendar = Calendar.current
    var groupedTransactions: [Date: [Transaction]] = [:]
    
    for transaction in transactions {
      let dayStart = calendar.startOfDay(for: transaction.date)
      if groupedTransactions[dayStart] == nil {
        groupedTransactions[dayStart] = []
      }
      groupedTransactions[dayStart]?.append(transaction)
    }
    
    let sortedDates = groupedTransactions.keys.sorted { $0 > $1 }
    
    return sortedDates.map { date in
      TransactionGroup(date: date, transactions: groupedTransactions[date] ?? [])
    }
  }
}
