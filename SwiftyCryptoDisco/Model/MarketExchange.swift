//
//  MarketExchange.swift
//  SwiftyCryptoDisco
//
//  Created by Mat Schmid on 2018-01-25.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import Foundation
import SwiftyJSON

struct MarketExchange {
    let symbolID        : String
    let exchangeID      : String
    let baseCurrencyID  : String
    let quoteCurrencyID : String
    
    init(withDictionary marketDictionary: JSON) {
        self.symbolID        = marketDictionary["symbol_id"].stringValue
        self.exchangeID      = marketDictionary["exchange_id"].stringValue
        self.baseCurrencyID  = marketDictionary["asset_id_base"].stringValue
        self.quoteCurrencyID = marketDictionary["asset_id_quote"].stringValue
    }
}
