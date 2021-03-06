//
//  Currency.swift
//  SwiftyCryptoDisco
//
//  Created by Mat Schmid on 2017-12-23.
//  Copyright © 2017 Mat Schmid. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Currency: Equatable {
    
    let id                  : String
    let name                : String
    let symbol              : String
    let rank                : Int
    let priceUSD            : NSNumber
    let priceBTC            : Double
    let priceCAD            : NSNumber?
    let dailyVolume         : Double
    let marketCapUSD        : Double
    let availableSupply     : Double
    let totalSupply         : Double
    let maxSupply           : Double?
    let percentChangeHourly : Double
    let percentChangeDaily  : Double
    let percentChangeWeekly : Double
    let lastUpdated         : TimeInterval
    
    init(withDictionary currencyDictionary: JSON) {
        self.id                     = currencyDictionary["id"].stringValue
        self.name                   = currencyDictionary["name"].stringValue
        self.symbol                 = currencyDictionary["symbol"].stringValue
        self.rank                   = currencyDictionary["rank"].intValue
        self.priceUSD               = currencyDictionary["price_usd"].numberValue
        self.priceBTC               = currencyDictionary["price_btc"].doubleValue
        self.priceCAD               = currencyDictionary["price_cad"].numberValue
        self.dailyVolume            = currencyDictionary["24h_volume_usd"].doubleValue
        self.marketCapUSD           = currencyDictionary["market_cap_usd"].doubleValue
        self.availableSupply        = currencyDictionary["available_supply"].doubleValue
        self.totalSupply            = currencyDictionary["total_supply"].doubleValue
        self.maxSupply              = currencyDictionary["max_supply"].doubleValue
        self.percentChangeHourly    = currencyDictionary["percent_change_1h"].doubleValue
        self.percentChangeDaily     = currencyDictionary["percent_change_24h"].doubleValue
        self.percentChangeWeekly    = currencyDictionary["percent_change_7d"].doubleValue
        self.lastUpdated            = currencyDictionary["last_updated"].doubleValue as TimeInterval
    }
    
    static func ==(lhs: Currency, rhs: Currency) -> Bool {
        return lhs.id == rhs.id
    }
}
