//
//  CoreDataManager.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 27.06.2025.
//

import CoreData
import Foundation

protocol CoreDataManagerProtocol {
  var persistentContainer: NSPersistentContainer { get }
  var context: NSManagedObjectContext { get }
  func saveContext()
}

class CoreDataManager: CoreDataManagerProtocol {
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
}

