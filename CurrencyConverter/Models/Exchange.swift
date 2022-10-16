//
//  Exchange.swift
//  CurrencyConverter
//
//  Created by Reggie Manuel Cabalo on 10/14/22.
//

import Foundation

enum Currency: String, Codable, CaseIterable {
  case EUR
  case JPY
  case USD

}

struct Exchange: Codable {
  var amount: String
  var currency: Currency
  
}
