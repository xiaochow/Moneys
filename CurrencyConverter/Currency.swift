//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Xiaoxiao on 3/4/16.
//  Copyright © 2016 WangXiaoxiao. All rights reserved.
//

import UIKit

class Currency: NSObject, NSCoding{
    
    //  MARK: Properties
    
    var name: String
    var country: String
    var rate: Double
    
    //  To store the index of selected currencies.
    static var firstSelection: Int = 0
    static var secondSelection: Int = 1
    
    //  MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("currencies")
    
    //  MARK: Types
    struct PropertyKey {
        
        static let nameKey = "name"
        static let countryKey = "country"
        static let rateKey = "rate"
        static let firstSelectionKey = "firstSelection"
        static let secondSelectionKey = "secondSelection"

    }

    //  MARK: Initialization
    init?(name: String, country: String, rate: Double) {
        
        self.name = name
        self.rate = rate
        self.country = country
        
        super.init()
        
        // Return nil if information is invalid.
        if name.isEmpty || rate < 0 || country.isEmpty {
            return nil
        }
    }
    
    //  MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.nameKey)
        aCoder.encode(country, forKey: PropertyKey.countryKey)
        aCoder.encode(rate, forKey: PropertyKey.rateKey)
        aCoder.encode(Currency.firstSelection, forKey: PropertyKey.firstSelectionKey)
        aCoder.encode(Currency.secondSelection, forKey: PropertyKey.secondSelectionKey)

    }
    
    //  NSCoding initiaition.
    required convenience init?(coder aDecoder: NSCoder) {
        
        let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String
        let country = aDecoder.decodeObject(forKey: PropertyKey.countryKey) as! String
        let rate = aDecoder.decodeDouble(forKey: PropertyKey.rateKey)
        
        Currency.firstSelection = aDecoder.decodeInteger(forKey: PropertyKey.firstSelectionKey)
        Currency.secondSelection = aDecoder.decodeInteger(forKey: PropertyKey.secondSelectionKey)
        
        self.init(name: name, country: country, rate: rate)
        
    }
    
}
