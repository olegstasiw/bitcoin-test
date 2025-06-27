//
//  TransactionGroup.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import Foundation

struct TransactionGroup {
  let date: Date
  let transactions: [Transaction]
  
  var formattedDate: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, MMM d"
    return formatter.string(from: date)
  }
}
