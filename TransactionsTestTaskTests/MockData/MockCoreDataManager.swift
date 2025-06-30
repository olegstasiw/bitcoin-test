//
//  MockCoreDataManager.swift
//  TransactionsTestTaskTests
//
//  Created by Oleg Stasiw on 30.06.2025.
//

import Foundation
import CoreData
@testable import TransactionsTestTask

class MockCoreDataManager: CoreDataManagerProtocol {
  var persistentContainer: NSPersistentContainer
  var context: NSManagedObjectContext
  
  init() {
    persistentContainer = NSPersistentContainer(name: "TransactionsTestTask")
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    persistentContainer.persistentStoreDescriptions = [description]
    
    persistentContainer.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    
    context = persistentContainer.viewContext
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

