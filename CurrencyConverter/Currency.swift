//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Xiaoxiao on 3/4/16.
//  Copyright © 2016 WangXiaoxiao. All rights reserved.
//

import UIKit

struct Currency: Codable{
    
    //  MARK: Properties
    
    var name: String = ""
    var country: String = ""
    var rate: Double = 0
    
    //  To store the index of selected currencies.
    static var firstSelection: Int = 0
    static var secondSelection: Int = 1
}

public let userDefaults = UserDefaults.init(suiteName: "group.com.Xiaoxw.CurrencyConverter")!

class LocalStorage {
    static let shared = LocalStorage()
    
    var currencies: [Currency] {
        get{
            do {
                if let dataString = userDefaults.string(forKey: "Currencies") {
                    if let currencyJSON = dataString.data(using: .utf8) {
                        let currencies = try JSONDecoder().decode([Currency].self, from: currencyJSON)
                        return currencies
                    }
                }
            }
            catch {
                print("Unable to get currencies object.")
            }
            return [Currency]()
        }
        set(currencies) {
            do {
                let currencyJSON = try JSONEncoder().encode(currencies)
                let dataString = String(data: currencyJSON, encoding: .utf8)
                userDefaults.set(dataString, forKey: "Currencies")
            }
            catch {
                print("Unable to set currencies object.")
            }
        }
    }
}
