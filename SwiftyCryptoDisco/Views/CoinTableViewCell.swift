//
//  CoinTableViewCell.swift
//  SwiftyCryptoDisco
//
//  Created by Mat Schmid on 2017-12-22.
//  Copyright © 2017 Mat Schmid. All rights reserved.
//

import UIKit
import SwiftyJSON

class CoinTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyPriceLabel: UILabel!
    @IBOutlet weak var currencyRankLabel: UILabel!
    @IBOutlet weak var currency24hrChangeLabel: UILabel!
    @IBOutlet weak var currencyArrowImageView: UIImageView!
    @IBOutlet weak var currencyDotSeperatorLabel: UILabel!
    @IBOutlet weak var currenceConversionLabel: UILabel!
    
    var coinSymbol: String?
    var coinName : String?
    var baseCurrency: BaseCurrency?
    
    func formatCellFor(currencyName: String) {
        
        let dataFetcher = CurrencyDataFetcher()
        dataFetcher.getDataForCurrency(currency: currencyName) { (coin) in
            guard let coin = coin else {
                print("Unable to get data for currency: \(currencyName)")
                return
            }
            self.currencyNameLabel.text = coin.name
            self.currencyRankLabel.text = "\(coin.rank)"
            self.currency24hrChangeLabel.text = String(format: "%0.2f%%", coin.percentChangeDaily)
            self.getBaseCurrency(coin: coin)
            self.coinSymbol = coin.symbol
            self.coinName = coin.name
            
            if coin.percentChangeDaily >= 0 {
                DispatchQueue.main.async {
                    self.currency24hrChangeLabel.textColor = UIColor(named: "fluoGreen")
                    self.currencyArrowImageView.tintColor = UIColor(named: "fluoGreen")
                    self.currencyDotSeperatorLabel.textColor = UIColor(named: "fluoGreen")
                    self.currencyArrowImageView.transform = CGAffineTransform(scaleX: 1, y: -1)
                }
            } else {
                DispatchQueue.main.async {
                    self.currency24hrChangeLabel.textColor = UIColor(named: "flatRed")
                    self.currencyArrowImageView.tintColor = UIColor(named: "flatRed")
                    self.currencyDotSeperatorLabel.textColor = UIColor(named: "flatRed")
                    //self.currencyArrowImageView.transform = CGAffineTransform(scaleX: 1, y: -1)
                }
            }
        }
    }
    
    func formatCellFor(coin: Currency) {
        self.currencyNameLabel.text = coin.name
        self.currencyPriceLabel.text = coin.priceCAD?.formattedCurrencyString
        self.currencyRankLabel.text = "\(coin.rank)"
        self.currency24hrChangeLabel.text = String(format: "%0.2f%%", coin.percentChangeDaily)
        self.getBaseCurrency(coin: coin)
        
        if coin.percentChangeDaily >= 0 {
            DispatchQueue.main.async {
                self.currency24hrChangeLabel.textColor = UIColor(named: "fluoGreen")
                self.currencyArrowImageView.tintColor = UIColor(named: "fluoGreen")
                self.currencyDotSeperatorLabel.textColor = UIColor(named: "fluoGreen")
                self.currencyArrowImageView.transform = CGAffineTransform(scaleX: 1, y: -1)
            }
        } else {
            DispatchQueue.main.async {
                self.currency24hrChangeLabel.textColor = UIColor(named: "flatRed")
                self.currencyArrowImageView.tintColor = UIColor(named: "flatRed")
                self.currencyDotSeperatorLabel.textColor = UIColor(named: "flatRed")
                //self.currencyArrowImageView.transform = CGAffineTransform(scaleX: 1, y: -1)
            }

        }
    }
    
    func getBaseCurrency(coin: Currency){
        if let fetchedBaseCurrency = defaults.object(forKey: kBaseCurrencyKey) {
            self.baseCurrency = BaseCurrency(rawValue: (fetchedBaseCurrency as? String)!)
        } else {
            self.baseCurrency = BaseCurrency.CAD
        }
        
        switch self.baseCurrency! {
        case .CAD:
            self.currencyPriceLabel.text = coin.priceCAD?.formattedCurrencyString
            self.currenceConversionLabel.text = coin.symbol + "/CAD"
        case .USD:
            self.currencyPriceLabel.text = coin.priceUSD.formattedCurrencyString
            self.currenceConversionLabel.text = coin.symbol + "/USD"
        case .BTC:
            self.currencyPriceLabel.text = "\(coin.priceBTC)"
            self.currenceConversionLabel.text = coin.symbol + "/BTC"
        }
    }
}
