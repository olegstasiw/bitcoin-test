//
//  MockBitcoinRateCacheManager.swift
//  TransactionsTestTaskTests
//
//  Created by Oleg Stasiw on 30.06.2025.
//

import Foundation
@testable import TransactionsTestTask

class MockBitcoinRateCacheManager: BitcoinRateCacheManager {
  var cachedRate: BitcoinRate?
  
  func cacheBitcoinRate(_ rate: BitcoinRate) {
    self.cachedRate = rate
  }
  
  func getCachedBitcoinRate() -> BitcoinRate? {
    return cachedRate
  }
  
  func clearCache() {
    self.cachedRate = nil
  }
}
