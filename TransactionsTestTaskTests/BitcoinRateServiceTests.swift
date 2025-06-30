//
//  BitcoinRateServiceTests.swift
//  TransactionsTestTaskTests
//
//  Created by Oleg Stasiw on 30.06.2025.
//

import Foundation
import XCTest
import Combine
@testable import TransactionsTestTask

class BitcoinRateServiceTests: XCTestCase {
  
  var bitcoinRateService: BitcoinRateService!
  var mockBitcoinRateCacheManager: MockBitcoinRateCacheManager!
  var cancellables: Set<AnyCancellable>!
  
  override func setUp() {
    super.setUp()
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses = [MockURLProtocol.self]
    let urlSession = URLSession.init(configuration: configuration)
    mockBitcoinRateCacheManager = MockBitcoinRateCacheManager()
    bitcoinRateService = BitcoinRateServiceImpl(bitcoinRateCacheManager: mockBitcoinRateCacheManager, session: urlSession)
    cancellables = Set<AnyCancellable>()
  }
  
  override func tearDown() {
    bitcoinRateService = nil
    mockBitcoinRateCacheManager = nil
    cancellables = nil
    super.tearDown()
  }
  
  func testGetBitcoinRateSuccess() {
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
    
    let expectation = self.expectation(description: "Bitcoin rate fetched successfully")
    bitcoinRateService.fetchCurrentBTCPrice { result in
      switch result {
      case .success(let rate):
        XCTAssertEqual(rate.price, "5000")
      case .failure:
        XCTFail("Expected success, got failure")
      }
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1)
  }
  
  func testGetBitcoinRateFailureWithDecodingError() {
    // should be a string, but we provide an integer to simulate decoding error
    let jsonString = """
      {
        "price": 5000
      }
    """
    
    let data = jsonString.data(using: .utf8)
    
    MockURLProtocol.loadingHandler = { request in
      let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
      return (data, response, nil)
    }
    
    let expectation = self.expectation(description: "Bitcoin rate fetched with decoding error")
    bitcoinRateService.fetchCurrentBTCPrice { result in
      switch result {
      case .success:
        XCTFail("Expected failure, got success")
      case .failure(let error):
        XCTAssertNotNil(error as? DecodingError)
      }
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1)
  }
  
  func testGetBitcoinRateFailureWithError() {
    let expectedError = NSError(domain: "TestError", code: 1)
    MockURLProtocol.loadingHandler = { request in
      return (nil, nil, expectedError)
    }
    
    let expectation = self.expectation(description: "Bitcoin rate fetched with error")
    bitcoinRateService.fetchCurrentBTCPrice { result in
      switch result {
      case .success:
        XCTFail("Expected failure, got success")
      case .failure(let error as NSError):
        XCTAssertEqual(error.code, expectedError.code)
        XCTAssertEqual(error.domain, expectedError.domain)
        XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
      }
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1)
  }
  
  func testGetBitcoinRateFromCache() throws {
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
    
    let expectation = self.expectation(description: "Bitcoin rate is cached successfully")
    bitcoinRateService.fetchCurrentBTCPrice { result in
      switch result {
      case .success(let rate):
        let cachedRate = self.mockBitcoinRateCacheManager.getCachedBitcoinRate()
        XCTAssertNotNil(cachedRate)
        XCTAssertEqual(rate.price, cachedRate?.price)
      case .failure:
        XCTFail("Expected success, got failure")
      }
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1)
  }
  
  func testFetchCurrentBTCPricePublishesToPublisher() {
    let expectation = XCTestExpectation(description: "Publisher receives rate")
    var publishedRate: BitcoinRate?
    
    bitcoinRateService.rateUpdatePublisher
      .sink { rate in
        publishedRate = rate
        expectation.fulfill()
      }
      .store(in: &cancellables)
    
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
    
    bitcoinRateService.fetchCurrentBTCPrice { _ in }
    
    wait(for: [expectation], timeout: 1)
    if let rate = publishedRate {
      XCTAssertNotNil(rate)
      XCTAssertFalse(rate.price.isEmpty)
      XCTAssertEqual(rate.price, "5000")
      XCTAssertTrue(Double(rate.price) != nil)
    }
  }
  
  func testRateUpdatePublisherWithMultipleSubscribers() {
    let expectation1 = XCTestExpectation(description: "First subscriber receives rate")
    let expectation2 = XCTestExpectation(description: "Second subscriber receives rate")
    var publishedRate1: BitcoinRate?
    var publishedRate2: BitcoinRate?
    
    bitcoinRateService.rateUpdatePublisher
      .sink { rate in
        publishedRate1 = rate
        expectation1.fulfill()
      }
      .store(in: &cancellables)
    
    bitcoinRateService.rateUpdatePublisher
      .sink { rate in
        publishedRate2 = rate
        expectation2.fulfill()
      }
      .store(in: &cancellables)
    
    
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
    
    bitcoinRateService.fetchCurrentBTCPrice { _ in }
    
    wait(for: [expectation1, expectation2], timeout: 1)
    if let rate1 = publishedRate1, let rate2 = publishedRate2 {
      XCTAssertEqual(rate1.price, rate2.price)
    }
  }
}
