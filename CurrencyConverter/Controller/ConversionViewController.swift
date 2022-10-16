//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Reggie Manuel Cabalo on 10/15/22.
//

import UIKit
import DropDown

class ConversionViewController: UIViewController {
  
  @IBOutlet weak var destination_currency_label: UILabel!
  @IBOutlet weak var balance_collection_view: UICollectionView!
  @IBOutlet weak var exchange_amount_textfield: UITextField!
  var conversion_VM = ConversionViewModel()
  var balance_VM = BalanceViewModel()
  let drop_down = DropDown()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.hide_keyboard_when_tapped_around()
    exchange_amount_textfield.addTarget(self,
                                        action: #selector(textFieldDidChange(_:)),
                                        for: .editingChanged)
    
  }
  
  @IBAction func convert(_ sender: Any) {
    balance_VM.update_balance(sourceCurrency: conversion_VM.source_currency,
                            destinationCurrency: conversion_VM.destination_currency,
                            sourceAmount: conversion_VM.convert_amount_to_double(
                              amount: exchange_amount_textfield.text!),
                            convertedAmount: Double(conversion_VM.exchange_model!.amount)!)
    
   
    if self.balance_VM.attemtps >= 5 && !self.balance_VM.has_error {
      
      self.display_alert("Currency converted", message: "You have converted \( self.exchange_amount_textfield.text!) \(self.conversion_VM.source_currency) to \(self.conversion_VM.exchange_model!.amount) \(self.conversion_VM.destination_currency). Commission Fee - \(String(format:"%.2f", self.balance_VM.commission_fee)) \(self.conversion_VM.source_currency).")
    } else if self.balance_VM.has_error {
      self.display_alert("Invalid", message: "Insufficient funds")
    }
    
    
    DispatchQueue.main.async {
      self.balance_collection_view.reloadData()
    }
  }
  
  @IBAction func select_current_currency(_ sender: UIButton) {
    drop_down_menu(sender)
  }
  
  @IBAction func select_destination_currency(_ sender: UIButton) {
    drop_down_menu(sender)
  }
  
  private func display_alert(_ title: String, message: String) {
    
    let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
  
    let done = UIAlertAction(title: "Done", style: .default, handler: { (action) -> Void in
        print("Done button tapped")
        
    })
    
    dialogMessage.addAction(done)
    
    self.present(dialogMessage, animated: true, completion: nil)
    
}
  
  private func drop_down_menu(_ sender: UIButton){
    drop_down.dataSource = Currency.allCases.map { $0.rawValue }
    drop_down.anchorView = sender
    drop_down.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
    drop_down.show()
    drop_down.selectionAction = { [weak self] (index: Int, item: String) in
      
      sender.setTitle(item, for: .normal)
      
      if sender.tag == 1 {
        self?.conversion_VM.source_currency = Currency(rawValue: sender.currentTitle!)!
        self?.balance_VM.source_currency_did_change = true
        
      } else {
        self?.conversion_VM.destination_currency = Currency(rawValue: sender.currentTitle!)!
      }
      
      let amount = self?.conversion_VM.convert_amount_to_double(amount: self?.exchange_amount_textfield.text ?? "")
      
      self?.conversion_VM.get_latest_conversion_rate(fromAmount: amount ?? 0.0,
                                                fromCurrency: self?.conversion_VM.source_currency ?? .EUR,
                                                toCurrency: self?.conversion_VM.destination_currency ?? .USD)
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
        self?.destination_currency_label.text = "+ \(self?.conversion_VM.exchange_model?.amount ?? "")"
      }
    }
    
    sender.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
  }
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    let amount = conversion_VM.convert_amount_to_double(amount: textField.text!)
    
    conversion_VM.get_latest_conversion_rate(fromAmount: amount,
                                        fromCurrency: conversion_VM.source_currency, toCurrency: conversion_VM.destination_currency)
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      self.destination_currency_label.text = "+ \(self.conversion_VM.exchange_model?.amount ?? "")"
    }
  }
  
}

//Setting up the CollectionView delegate and data source
extension ConversionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return balance_VM.balance_list.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    var cell  = UICollectionViewCell()
    if let balanceCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BalanceCell",
                                                            for: indexPath) as? BalanceCollectionViewCell {
      balanceCell.balance_and_currency.text = "\(String(format:"%.2f", balance_VM.balance_list[indexPath.row].current_balance)) \(balance_VM.balance_list[indexPath.row].currency.rawValue)"
      
      cell = balanceCell
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
}

//Dismiss the keyboard when tapped
extension UIViewController {
  func hide_keyboard_when_tapped_around() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismiss_keyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismiss_keyboard() {
    view.endEditing(true)
  }
}




