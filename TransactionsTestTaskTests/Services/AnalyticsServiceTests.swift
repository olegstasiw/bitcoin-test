//
//  AnalyticsServiceTests.swift
//  TransactionsTestTaskTests
//
//  Created by Oleg Stasiw on 30.06.2025.
//

import Foundation
import XCTest
@testable import TransactionsTestTask

final class AnalyticsServiceTests: XCTestCase {
  
  var analyticsService: AnalyticsService!
  
  override func setUp() {
    super.setUp()
    analyticsService = AnalyticsServiceImpl()
  }
  
  override func tearDown() {
    analyticsService = nil
    super.tearDown()
  }
  
  func testTrackEvent() {
    analyticsService.trackEvent(name: "Test Event", parameters: ["TestKey" : "TestValue"])
    
    let events = analyticsService.getTrackedEvents()
    XCTAssertEqual(events.count, 1)
    XCTAssertEqual(events.first?.name, "Test Event")
    XCTAssertEqual(events.first?.parameters["TestKey"], "TestValue")
    XCTAssertNotNil(events.first?.date)
  }
}
