//
//  RateListenerLoggerTests.swift
//  TransactionsTestTaskTests
//
//  Created by Oleg Stasiw on 30.06.2025.
//

import Foundation
import XCTest
@testable import TransactionsTestTask

class RateListenerLoggerTests: XCTestCase {
  
  var rateListenerLogger: RateListenerLogger!
  var mockAnalyticsService: MockAnalyticsService!
  var bitcoinRateService: BitcoinRateService!
  var bitcoinRateCacheManager: BitcoinRateCacheManager!
    
  override func setUp() {
    super.setUp()
    mockAnalyticsService = MockAnalyticsService()
    bitcoinRateCacheManager = MockBitcoinRateCacheManager()
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses = [MockURLProtocol.self]
    let urlSession = URLSession.init(configuration: configuration)
    bitcoinRateService = BitcoinRateServiceImpl(bitcoinRateCacheManager: bitcoinRateCacheManager, session: urlSession)
    rateListenerLogger = RateListenerLoggerImpl(analyticsService: mockAnalyticsService,
                                                bitcoinRateService: bitcoinRateService)
  }
  
  override func tearDown() {
    rateListenerLogger = nil
    mockAnalyticsService = nil
    bitcoinRateService = nil
    bitcoinRateCacheManager = nil
    super.tearDown()
  }
  
  func testAnalitycsCalledOnce() {
    prepareForSuccessResponse()
    let expectation = self.expectation(description: "Bitcoin rate fetched successfully")
    
    bitcoinRateService.fetchCurrentBTCPrice { result in
      switch result {
      case .success:
        XCTAssertEqual(self.mockAnalyticsService.trackEventCalledCount, 1)
        XCTAssertEqual(self.mockAnalyticsService.calledTrackEventNames, "bitcoin_rate_update")
        XCTAssertNotNil(self.mockAnalyticsService.calledTrackEventParameters)
      case .failure:
        XCTFail("Expected success but got failure")
      }
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1)
  }
  
  private func prepareForSuccessResponse() {
    let jsonString = """
      {
        "price": "5000"
      }
    """
    
    let data = jsonString.data(using: .utf8)
    
    MockURLProtocol.loadingHandler = { request in
      let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
      return (data, response, nil)
    }
  }
}
