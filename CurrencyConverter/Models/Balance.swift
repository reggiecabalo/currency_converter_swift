//
//  Balance.swift
//  CurrencyConverter
//
//  Created by Reggie Manuel Cabalo on 10/14/22.
//

import Foundation


struct Balance {
  var current_balance: Double
  var currency: Currency
  
  init(current_balance: Double, currency: Currency) {
    self.current_balance = current_balance
    self.currency = currency
  }
}
