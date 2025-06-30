//
//  MockBitcoinRateService.swift
//  TransactionsTestTaskTests
//
//  Created by Oleg Stasiw on 30.06.2025.
//

import Foundation
import Combine
@testable import TransactionsTestTask

class MockBitcoinRateService: BitcoinRateService {
  var rateUpdatePublisher: PassthroughSubject<BitcoinRate, Never> = PassthroughSubject()
  var fetchCurrentBTCPriceCalled = false
  var getCachedBitcoinRateCalled = false
  var shouldReturnSuccess = true
  var mockBitcoinRate: BitcoinRate?
  var mockError: Error?
  
  func fetchCurrentBTCPrice(completion: @escaping (Result<BitcoinRate, Error>) -> Void) {
    fetchCurrentBTCPriceCalled = true
    
    if shouldReturnSuccess {
      let rate = BitcoinRate(price: "50000.00", date: Date())
      completion(.success(rate))
    } else {
      completion(.failure(mockError ?? NSError(domain: "Test", code: 1, userInfo: nil)))
    }
  }
  
  func getCachedBitcoinRate() -> BitcoinRate? {
    getCachedBitcoinRateCalled = true
    return mockBitcoinRate
  }
}
