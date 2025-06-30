//
//  Transaction.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import Foundation

struct Transaction: Identifiable {
  let id = UUID()
  let amount: Double
  let type: TransactionType
  let category: TransactionCategory?
  let date: Date
  
  init(amount: Double, type: TransactionType, category: TransactionCategory? = nil, date: Date = Date()) {
    self.amount = amount
    self.type = type
    self.category = category
    self.date = date
  }
}
