//
//  MarketDataFetcher.swift
//  SwiftyCryptoDisco
//
//  Created by Mat Schmid on 2018-01-25.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import Alamofire
import SwiftyJSON

class MarketDataFetcher {
    
    // RESTful Market data provided by CoinAPI
    // Reference documentation can be found at https://docs.coinapi.io/#rest-api
    
    let APIKey = "55DCAFC7-20C7-4099-8BDA-2C4421377405"
    
    func getMarketDataForBaseCurrency(baseCurrency: String, completion: @escaping(_ exchanges: [MarketExchange]?) -> Void) {
        let header : HTTPHeaders = [
            "X-CoinAPI-Key": APIKey
        ]
        Alamofire.request("https://rest.coinapi.io/v1/symbols/", headers: header).responseJSON { (response) in
            if let data = response.data {
                let json = JSON(data)
                var marketArray: [MarketExchange] = []
                for subJson in json {
                    if subJson.1["asset_id_base"].stringValue == baseCurrency {
                        print(subJson.1)
                        let marketExchange = MarketExchange(withDictionary: subJson.1)
                        marketArray.append(marketExchange)
                    }
                }
                completion(marketArray)
            } else {
                completion(nil)
            }
        }
    }
    
    func getOHLCVDataForSymbol(symbol: String, period: Period, completion: @escaping(_ ohlcvs: [OHLCV]?) -> Void) {
        let header : HTTPHeaders = [
            "X-CoinAPI-Key": APIKey
        ]
        Alamofire.request("https://rest.coinapi.io/v1/ohlcv/\(symbol)/latest?period_id=\(period.rawValue)", headers: header).responseJSON { (response) in
            if let data = response.data {
                let json = JSON(data)
                var ohlcvArray: [OHLCV] = []
                for subJson in json {
                    print(subJson)
                    let ohlcv = OHLCV(withDictionary: subJson.1)
                    ohlcvArray.append(ohlcv)
                }
                completion(ohlcvArray)
            } else {
                completion(nil)
            }
        }
    }
}
