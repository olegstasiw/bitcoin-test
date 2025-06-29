//
//  ServicesAssembler.swift
//  TransactionsTestTask
//
//

import Foundation
import Combine

enum ServicesAssembler {
  
  static let bitcoinRateCacheManager: PerformOnce<BitcoinRateCacheManager> = {
    let service = BitcoinRateCacheManagerImpl()
    return { service }
  }()
  
  static let bitcoinRateService: PerformOnce<BitcoinRateService> = {
    let cacheManager = bitcoinRateCacheManager()
    let service = BitcoinRateServiceImpl(bitcoinRateCacheManager: cacheManager)
    return { service }
  }()
  
  static let analyticsService: PerformOnce<AnalyticsService> = {
    let service = AnalyticsServiceImpl()
    return { service }
  }()
  
  static let transactionService: PerformOnce<TransactionService> = {
    let coreDataManager = CoreDataManager.shared
    let service = TransactionServiceImpl(coreDataManager: coreDataManager)
    return { service }
  }()
  
  static let rateListenerLogger: PerformOnce<RateListenerLogger> = {
    let service = RateListenerLoggerImpl(analyticsService: analyticsService(),
                                         bitcoinRateService: bitcoinRateService())
    return { service }
  }()
}
