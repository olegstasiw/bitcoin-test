//
//  CoreDataManager.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import CoreData
import Foundation

class CoreDataManager {
  static let shared = CoreDataManager()
  
  private init() {}
  
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "TransactionsTestTask")
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  var context: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  
  func saveContext() {
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let error = error as NSError
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
  }
  
  func createTransaction(amount: Double, type: TransactionType, category: TransactionCategory? = nil, date: Date = Date(), description: String? = nil) {
    let transaction = TransactionEntity(context: context)
    transaction.amount = amount
    transaction.type = type.rawValue
    transaction.category = category?.rawValue
    transaction.date = date
    transaction.transactionDescription = description
    
    saveContext()
  }
  
  func fetchAllTransactions() -> [TransactionEntity] {
    let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
    
    do {
      return try context.fetch(request)
    } catch {
      print("Error fetching transactions: \(error)")
      return []
    }
  }
  
  func deleteTransaction(_ transaction: TransactionEntity) {
    context.delete(transaction)
    saveContext()
  }
  
  func deleteAllTransactions() {
    let request: NSFetchRequest<NSFetchRequestResult> = TransactionEntity.fetchRequest()
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
    
    do {
      try context.execute(deleteRequest)
      saveContext()
    } catch {
      print("Error deleting all transactions: \(error)")
    }
  }
}

