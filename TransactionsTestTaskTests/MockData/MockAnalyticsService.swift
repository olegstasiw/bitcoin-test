//
//  MockAnalyticsService.swift
//  TransactionsTestTaskTests
//
//  Created by Oleg Stasiw on 30.06.2025.
//

import Foundation
@testable import TransactionsTestTask

class MockAnalyticsService: AnalyticsService {
  var trackEventCalledCount = 0
  var calledTrackEventNames: String?
  var calledTrackEventParameters: [String: String]?
  
  func trackEvent(name: String, parameters: [String : String]) {
    self.calledTrackEventNames = name
    self.calledTrackEventParameters = parameters
    trackEventCalledCount += 1
  }
  
  func getTrackedEvents() -> [AnalyticsEvent] { return [] }
}
