//
//  BitcoinRateService.swift
//  TransactionsTestTask
//
//

import Foundation
import Combine

protocol BitcoinRateService: AnyObject {
  func fetchCurrentBTCPrice(completion: @escaping (Result<BitcoinRate, Error>) -> Void)
  func getCachedBitcoinRate() -> BitcoinRate?
  var rateUpdatePublisher: PassthroughSubject<BitcoinRate, Never> { get }
}

private struct BitcoinRateResponse: Decodable {
  let price: String
}

enum BitcoinRateServiceError: Error {
    case invalidURL
    case noData
}

final class BitcoinRateServiceImpl {
  
  private struct Constants {
    static let host = "api.binance.com"
    static let path = "/api/v3/ticker/price"
    static let symbolQueryItemName = "symbol"
    static let symbolQueryItemValue = "BTCUSDT"
  }
  
  private let session: URLSession
  var rateUpdatePublisher: PassthroughSubject<BitcoinRate, Never> = PassthroughSubject()
  var bitcoinRateCacheManager: BitcoinRateCacheManager
  
  init(bitcoinRateCacheManager: BitcoinRateCacheManager,
       session: URLSession = URLSession.shared) {
    self.bitcoinRateCacheManager = bitcoinRateCacheManager
    self.session = session
  }
}

extension BitcoinRateServiceImpl: BitcoinRateService {
  
  /// Returns the current BTC price in USD
  func fetchCurrentBTCPrice(completion: @escaping (Result<BitcoinRate, Error>) -> Void) {
    var components = URLComponents()
    components.scheme = "https"
    components.host = Constants.host
    components.path = Constants.path
    components.queryItems = [
      URLQueryItem(name: Constants.symbolQueryItemName, value: Constants.symbolQueryItemValue)
    ]
    
    guard let url = components.url else {
      completion(.failure(BitcoinRateServiceError.invalidURL))
      return
    }
    
    let task = session.dataTask(with: url) { [weak self] data, _, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      guard let data = data else {
        completion(.failure(BitcoinRateServiceError.noData))
        return
      }
      do {
        let decoded = try JSONDecoder().decode(BitcoinRateResponse.self, from: data)
        let rate = BitcoinRate(price: decoded.price, date: Date())
        self?.rateUpdatePublisher.send(rate)
        self?.bitcoinRateCacheManager.cacheBitcoinRate(rate)
        completion(.success(rate))
      } catch {
        completion(.failure(error))
      }
    }
    
    task.resume()
  }
  
  func getCachedBitcoinRate() -> BitcoinRate? {
    return bitcoinRateCacheManager.getCachedBitcoinRate()
  }
}
