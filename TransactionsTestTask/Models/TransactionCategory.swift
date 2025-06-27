//
//  TransactionCategory.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import Foundation

enum TransactionCategory: String, CaseIterable {
  case groceries = "groceries"
  case taxi = "taxi"
  case electronics = "electronics"
  case restaurant = "restaurant"
  case other = "other"
  
  var displayName: String {
    switch self {
    case .groceries: return "Groceries"
    case .taxi: return "Taxi"
    case .electronics: return "Electronics"
    case .restaurant: return "Restaurant"
    case .other: return "Other"
    }
  }
  
  var icon: String {
    switch self {
    case .groceries: return "cart"
    case .taxi: return "car"
    case .electronics: return "laptopcomputer"
    case .restaurant: return "fork.knife"
    case .other: return "ellipsis.circle"
    }
  }
}
