//
//  BitcoinRateCacheManagerTests.swift
//  TransactionsTestTaskTests
//
//  Created by Oleg Stasiw on 30.06.2025.
//

import Foundation
import XCTest
@testable import TransactionsTestTask

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

class BitcoinRateCacheManagerTests: XCTestCase {
  
  var cacheManager: BitcoinRateCacheManager!
  var mockUserDefaults: MockUserDefault!
  
  override func setUp() {
    super.setUp()
    mockUserDefaults = MockUserDefault()
    cacheManager = BitcoinRateCacheManagerImpl(userDefaults: mockUserDefaults)
  }
  
  override func tearDown() {
    cacheManager = nil
    mockUserDefaults = nil
    super.tearDown()
  }
  
  func testSaveBitcoinRate() {
    let rate = BitcoinRate(price: "30000.0", date: Date())
    cacheManager.cacheBitcoinRate(rate)
    
    XCTAssertNotNil(mockUserDefaults.persistedData)
    XCTAssertEqual(mockUserDefaults.persistenceKey, "bitcoin_rate_cache")
  }
  
  func testLoadBitcoinRate() {
    let rate = BitcoinRate(price: "30000.0", date: Date())
    cacheManager.cacheBitcoinRate(rate)
    
    let loadedRate = cacheManager.getCachedBitcoinRate()
    XCTAssertNotNil(loadedRate)
    XCTAssertEqual(loadedRate?.price, "30000.0")
  }
  
  func testClearAllCache() {
    let rate = BitcoinRate(price: "30000.0", date: Date())
    cacheManager.cacheBitcoinRate(rate)
    
    cacheManager.clearCache()
    
    XCTAssertNil(mockUserDefaults.persistedData)
  }
}
