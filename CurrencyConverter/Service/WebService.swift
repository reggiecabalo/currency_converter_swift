//
//  WebService.swift
//  CurrencyConverter
//
//  Created by Reggie Manuel Cabalo on 10/14/22.
//

import Foundation

enum NetworkError : Error {
  case urlError
  case domainError
}

struct Resource <T: Codable> {
  let fromAmount: Double
  let fromCurrency: Currency
  let toCurrency: Currency
}

class WebService {
  private let baseURL = "http://api.evp.lt/currency/commercial/exchange/"
  func latestRateConvrsion<T>(resource: Resource<T>, completion: @escaping(Result<T, NetworkError>) -> Void) {
    
    let sourceURL = URL(string: baseURL + "\(resource.fromAmount)-\(resource.fromCurrency)/\(resource.toCurrency)/latest")!
    
    URLSession.shared.dataTask(with: sourceURL) { data, response, error in
      guard let data = data, error == nil else {
        completion(.failure(.domainError))
        return
      }
      
      let result = try? JSONDecoder().decode(T.self, from: data)
      if let result = result {
        DispatchQueue.main.async {
          completion(.success(result))
        }
      } else {
        completion(.failure(.urlError))
      }
    }.resume()
  }

}
