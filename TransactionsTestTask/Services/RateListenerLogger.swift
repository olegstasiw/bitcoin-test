//
//  RateListenerLogger.swift
//  TransactionsTestTask
//
//  Created by Oleg Stasiw on 29.06.2025.
//

import Foundation
import Combine

protocol RateListenerLogger: AnyObject {
  var analyticsService: AnalyticsService { get }
}

class RateListenerLoggerImpl: RateListenerLogger {
  private var cancellables = Set<AnyCancellable>()
  var analyticsService: AnalyticsService
  
  init(analyticsService: AnalyticsService, bitcoinRateService: BitcoinRateService) {
    self.analyticsService = analyticsService
    bitcoinRateService.rateUpdatePublisher.sink { [weak self] rate in
      self?.logRateUpdate(rate: rate)
    }
    .store(in: &cancellables)
  }
  
  private func logRateUpdate(rate: BitcoinRate) {
    let doubleRate = Double(rate.price) ?? 0.0
    analyticsService.trackEvent(
      name: "bitcoin_rate_update",
      parameters: ["rate": String(format: "%.2f", doubleRate),]
    )
  }
}
