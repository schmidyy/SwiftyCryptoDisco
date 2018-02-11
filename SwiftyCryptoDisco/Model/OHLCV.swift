//
//  OHLCV.swift
//  SwiftyCryptoDisco
//
//  Created by Mat Schmid on 2018-01-25.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import Foundation
import SwiftyJSON

struct OHLCV {
    let timePeriodStart : String
    let priceOpen       : NSNumber
    let priceHigh       : NSNumber
    let priceLow        : NSNumber
    let priceClose      : NSNumber
    let volume          : NSNumber
    
    init(withDictionary ohlcvDictionary: JSON) {
        self.timePeriodStart = ohlcvDictionary["time_period_start"].stringValue
        self.priceOpen       = ohlcvDictionary["price_open"].numberValue
        self.priceHigh       = ohlcvDictionary["price_high"].numberValue
        self.priceLow        = ohlcvDictionary["price_low"].numberValue
        self.priceClose      = ohlcvDictionary["price_close"].numberValue
        self.volume          = ohlcvDictionary["volume_traded"].numberValue
    }
}
