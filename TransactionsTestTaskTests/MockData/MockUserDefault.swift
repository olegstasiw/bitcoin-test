//
//  MockUserDefault.swift
//  TransactionsTestTaskTests
//
//  Created by Oleg Stasiw on 30.06.2025.
//

import Foundation

class MockUserDefault: UserDefaults {
  var persistedData: Data? = nil
  var persistenceKey: String? = nil
  
  override func set(_ value: Any?, forKey defaultName: String) {
    persistedData = value as? Data
    persistenceKey = defaultName
  }
  
  override func data(forKey defaultName: String) -> Data? {
    return persistedData
  }
  
  override func removeObject(forKey defaultName: String) {
    persistedData = nil
  }
}
