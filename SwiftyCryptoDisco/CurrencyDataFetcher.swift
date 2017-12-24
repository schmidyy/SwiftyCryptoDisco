//
//  CurrencyDataFetcher.swift
//  SwiftyCryptoDisco
//
//  Created by Mat Schmid on 2017-12-22.
//  Copyright © 2017 Mat Schmid. All rights reserved.
//

import Alamofire
import SwiftyJSON

class CurrencyDataFetcher {
    
    // Coin data provided by CoinMarketCap
    // See documentation at https://coinmarketcap.com/api/
    
    func getDataForCurrency(currency: String, completion: @escaping(_ coin: Currency?) -> Void) {
        let currencyURL = "https://api.coinmarketcap.com/v1/ticker/\(currency)/?convert=CAD"
        Alamofire.request(currencyURL).responseJSON { (response) in
            if let data = response.data {
                let json = JSON(data)
                let coin = Currency(withDictionary: json[0])
                completion(coin)
            } else {
                completion(nil)
            }
        }
    }
    
    func getDataForAllCurencies(completion: @escaping(_ coins: [Currency]?) -> Void) {
        let apiURL = "https://api.coinmarketcap.com/v1/ticker/"
        var coins : [Currency] = []
        Alamofire.request(apiURL).responseJSON { (response) in
            if let data = response.data {
                let json = JSON(data)
                for subJson in json {
                    let coin = Currency(withDictionary: subJson.1)
                    print(coin.name)
                    coins.append(coin)
                }
                completion(coins)
            }
        }
    }
}
