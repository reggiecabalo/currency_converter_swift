//
//  BalanceViewModel.swift
//  CurrencyConverter
//
//  Created by Reggie Manuel Cabalo on 10/15/22.
//

import Foundation

class BalanceViewModel {
  
  var balance_list : [Balance] = [
    Balance(current_balance: 1000.00, currency: .EUR),
    Balance(current_balance: 0.00, currency: .JPY),
    Balance(current_balance: 0.00, currency: .USD)
  ]
  
  var attemtps: Int = 0
  var commission_fee = 0.0
  var has_error = false
  var source_currency_did_change = false
  
  func update_balance(sourceCurrency: Currency, destinationCurrency: Currency, sourceAmount: Double, convertedAmount: Double) {
    
    revert_error_to_false_when_currency_changed()
    
    if let row_source = self.balance_list.firstIndex(where: {$0.currency == sourceCurrency}) {
      
      // Sets the commisison rate base on the currency selected
      commission_fee = commission_rate(currency: sourceCurrency)
      
      //Checks for the number of attempts to apply the commission fee
      if attemtps >= 5 {
        let maximum_trade = sourceAmount + commission_fee

        if  balance_list[row_source].current_balance < maximum_trade {
          print("insufficient balance")
          has_error = true
          return
        }
        balance_list[row_source].current_balance -= maximum_trade
      } else {
        balance_list[row_source].current_balance -= sourceAmount
      }
    }
    
    if let row_destination = self.balance_list.firstIndex(where: {$0.currency == destinationCurrency}) {
      balance_list[row_destination].current_balance += convertedAmount
    }
    attemtps += 1
  }
  
  func revert_error_to_false_when_currency_changed() {
    if source_currency_did_change {
      has_error = false
    }
  }
  
  func commission_rate(currency: Currency) -> Double {
    switch currency {
    case .EUR:
      return 0.70
    default:
      return 0.70
    }
  }
}
