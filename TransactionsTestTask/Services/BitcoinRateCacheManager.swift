//
//  BitcoinRateCacheManager.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 29.06.2025.
//

import Foundation

protocol BitcoinRateCacheManager {
    func cacheBitcoinRate(_ rate: BitcoinRate)
    func getCachedBitcoinRate() -> BitcoinRate?
    func clearCache()
}

class BitcoinRateCacheManagerImpl: BitcoinRateCacheManager {
  
  private let cacheKey = "bitcoin_rate_cache"
  private let userDefaults: UserDefaults
  
  init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
  }

  
  func cacheBitcoinRate(_ rate: BitcoinRate) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(rate) {
      userDefaults.set(encoded, forKey: cacheKey)
    }
  }
  
  func getCachedBitcoinRate() -> BitcoinRate? {
    guard let savedData = userDefaults.data(forKey: cacheKey) else { return nil }
    let decoder = JSONDecoder()
    return try? decoder.decode(BitcoinRate.self, from: savedData)
  }
  
  func clearCache() {
    userDefaults.removeObject(forKey: cacheKey)
  }
}
