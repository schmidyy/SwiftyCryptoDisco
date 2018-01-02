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
    
    func formatCellFor(currencyName: String) {
        
        let dataFetcher = CurrencyDataFetcher()
        dataFetcher.getDataForCurrency(currency: currencyName) { (coin) in
            guard let coin = coin else {
                print("Unable to get data for currency: \(currencyName)")
                return
            }
            self.currencyNameLabel.text = coin.name
            self.currencyPriceLabel.text = coin.priceCAD?.formattedCurrencyString
            self.currencyRankLabel.text = "\(coin.rank)"
            self.currency24hrChangeLabel.text = String(format: "%0.2f%%", coin.percentChangeDaily)
            self.currenceConversionLabel.text = coin.symbol + "/CAD"
            
            if coin.percentChangeDaily >= 0 {
                DispatchQueue.main.async {
                    self.currency24hrChangeLabel.textColor = UIColor(named: "fluoGreen")
                    self.currencyArrowImageView.tintColor = UIColor(named: "fluoGreen")
                    self.currencyDotSeperatorLabel.textColor = UIColor(named: "fluoGreen")
                    self.currencyArrowImageView.transform = CGAffineTransform(scaleX: 1, y: -1)
                }
            }
            
        }
    }
    
    func formatCellFor(coin: Currency) {
        self.currencyNameLabel.text = coin.name
        self.currencyPriceLabel.text = coin.priceCAD?.formattedCurrencyString
        self.currencyRankLabel.text = "\(coin.rank)"
        self.currency24hrChangeLabel.text = String(format: "%0.2f%%", coin.percentChangeDaily)
        self.currenceConversionLabel.text = coin.symbol + "/CAD"
        
        if coin.percentChangeDaily >= 0 {
            DispatchQueue.main.async {
                self.currency24hrChangeLabel.textColor = UIColor(named: "fluoGreen")
                self.currencyArrowImageView.tintColor = UIColor(named: "fluoGreen")
                self.currencyDotSeperatorLabel.textColor = UIColor(named: "fluoGreen")
                self.currencyArrowImageView.transform = CGAffineTransform(scaleX: 1, y: -1)
            }
        }
    }
}

private extension NSNumber {
    
    /// Takes an optional NSNumber and converts it to USD String
    ///
    /// - Parameter value: The NSNumber to convert to a USD String
    /// - Returns: The USD String or nil in the case of failure
    var formattedCurrencyString: String? {
        /// Construct a NumberFormatter that uses the US Locale and the currency style
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        return formatter.string(from: self)
    }
    
}
