//
//  MockURLProtocol.swift
//  TransactionsTestTaskTests
//
//  Created by Oleg Stasiw on 30.06.2025.
//

import Foundation

typealias MockURLHandler = (data: Data?, response: URLResponse?, error: Error?)

final class MockURLProtocol: URLProtocol {
  
  static var loadingHandler: ((URLRequest) throws -> (MockURLHandler))?
  
  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }
  
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
  
  override func startLoading() {
    guard let handler = MockURLProtocol.loadingHandler else {
      fatalError("Handler not set.")
    }
    
    do {
      let (data, response, error) = try handler(request)
      
      if let error = error {
        client?.urlProtocol(self, didFailWithError: error)
      } else {
        if let response = response {
          client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        if let data = data {
          client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
      }
    } catch {
      client?.urlProtocol(self, didFailWithError: error)
    }
  }
  
  override func stopLoading() {}
}
