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
  @Published var isLoading: Bool = false
  @Published var hasMoreData: Bool = false
  
  private var cancellables = Set<AnyCancellable>()
  private var currentOffset: Int = 0
  private let pageSize: Int = 10
  private var isLoadingMore: Bool = false
  
  private init() {
    setupObservers()
    loadInitialData()
  }
  
  private func setupObservers() {
    NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave, object: coreDataManager.context)
      .sink { [weak self] _ in
        self?.refreshData()
      }
      .store(in: &cancellables)
  }
  
  private func loadInitialData() {
    guard !isLoading else { return }
    isLoading = true
    currentOffset = 0
    
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let self = self else { return }
      
      let transactionEntities = self.coreDataManager.fetchTransactionsWithPagination(offset: 0, limit: self.pageSize)
      let totalCount = self.coreDataManager.getTotalTransactionCount()
      
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
      let balance = self.calculateBalance(from: self.coreDataManager.fetchAllTransactions())
      
      DispatchQueue.main.async {
        self.transactions = groupedTransactions
        self.currentBalance = balance
        self.currentOffset = transactionEntities.count
        self.hasMoreData = self.currentOffset < totalCount
        self.isLoading = false
      }
    }
  }
  
  func loadMoreData() {
    guard !isLoadingMore && hasMoreData else { return }
    isLoadingMore = true
    
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let self = self else { return }
      
      let transactionEntities = self.coreDataManager.fetchTransactionsWithPagination(offset: self.currentOffset, limit: self.pageSize)
      let totalCount = self.coreDataManager.getTotalTransactionCount()
      
      let newTransactions = transactionEntities.map { entity in
        Transaction(
          amount: entity.amount,
          type: TransactionType(rawValue: entity.type ?? "expense") ?? .expense,
          category: entity.category.flatMap { TransactionCategory(rawValue: $0) },
          date: entity.date ?? Date(),
          description: entity.transactionDescription
        )
      }
      
      let newGroupedTransactions = self.groupTransactionsByDate(newTransactions)
      
      DispatchQueue.main.async {
        // Merge new transactions with existing ones
        var updatedTransactions = self.transactions
        
        for newGroup in newGroupedTransactions {
          if let existingIndex = updatedTransactions.firstIndex(where: { $0.date == newGroup.date }) {
            // Merge transactions for the same date
            var existingTransactions = updatedTransactions[existingIndex].transactions
            existingTransactions.append(contentsOf: newGroup.transactions)
            updatedTransactions[existingIndex] = TransactionGroup(date: newGroup.date, transactions: existingTransactions)
          } else {
            // Add new date group
            updatedTransactions.append(newGroup)
          }
        }
        
        updatedTransactions.sort { $0.date > $1.date }
        
        self.transactions = updatedTransactions
        self.currentOffset += transactionEntities.count
        self.hasMoreData = self.currentOffset < totalCount
        self.isLoadingMore = false
      }
    }
  }
  
  private func refreshData() {
    loadInitialData()
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
