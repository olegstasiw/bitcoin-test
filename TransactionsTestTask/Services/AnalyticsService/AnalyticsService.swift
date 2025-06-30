//
//  AnalyticsService.swift
//  TransactionsTestTask
//
//

import Foundation

protocol AnalyticsService: AnyObject {
  func trackEvent(name: String, parameters: [String: String])
  func getTrackedEvents() -> [AnalyticsEvent]
}

final class AnalyticsServiceImpl {
  
  private var events: [AnalyticsEvent] = []
  
  // MARK: - Init
  
  init() {}
}

extension AnalyticsServiceImpl: AnalyticsService {
  
  func getTrackedEvents() -> [AnalyticsEvent] {
    return events
  }
  
  func trackEvent(name: String, parameters: [String: String]) {
    let event = AnalyticsEvent(name: name,
                               parameters: parameters,
                               date: .now)
    
    events.append(event)
    print("Event tracked: \(event.name) with parameters: \(event.parameters) at \(event.date)")
  }
}
