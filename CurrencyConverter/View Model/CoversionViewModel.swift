//
//  CoversionViewModel.swift
//  CurrencyConverter
//
//  Created by Reggie Manuel Cabalo on 10/14/22.
//

import Foundation


class ConversionViewModel {
  
  private var api_service = WebService()
  var exchange_model : Exchange?
  var source_currency : Currency = Currency.EUR
  var destination_currency : Currency = Currency.USD
  
  
  func get_latest_conversion_rate(fromAmount: Double, fromCurrency: Currency, toCurrency: Currency) {
    
    let resource = Resource<Exchange>(fromAmount: fromAmount, fromCurrency: fromCurrency, toCurrency: toCurrency)

    api_service.latestRateConvrsion(resource: resource) { result in
    
      switch result {
      case .success(let exchange):
        self.exchange_model = exchange
      case .failure(let error):
        print(error)
      }
    }

  }
  
  func convert_amount_to_double(amount: String) -> Double {
    return Double(amount) ?? 0.0
  }
}
