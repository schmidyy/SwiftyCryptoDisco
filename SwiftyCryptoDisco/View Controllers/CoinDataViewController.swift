//
//  CoinDataViewController.swift
//  SwiftyCryptoDisco
//
//  Created by Mat Schmid on 2018-01-09.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import UIKit

class CoinDataViewController: UIViewController {
    
    var coinSymbol: String?
    var availableMarkets: [MarketExchange]?
    var currentOHLCVValues: [OHLCV]?
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarTitle()
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        self.view.addSubview(activityIndicator)
        self.activityIndicator.startAnimating()
        
        receiveMarketDataForSymbol(coinSymbol: coinSymbol!)
    }
    
    func setupNavBarTitle() {
        var baseCurrency: BaseCurrency
        if let fetchedBaseCurrency = defaults.object(forKey: kBaseCurrencyKey) {
            baseCurrency = BaseCurrency(rawValue: (fetchedBaseCurrency as? String)!)!
        } else {
            baseCurrency = BaseCurrency.CAD
        }
        self.title = "\(coinSymbol!)/\(baseCurrency.rawValue)"
    }
    
    //MARK: - Data Retrieval
    func receiveMarketDataForSymbol(coinSymbol: String) {
        let marketDataFetcher = MarketDataFetcher()
        marketDataFetcher.getMarketDataForBaseCurrency(baseCurrency: coinSymbol) { (markets) in
            guard let marketsForCoin = markets, marketsForCoin.count > 0 else {
                let alert = UIAlertController(title: "Error", message: "No exchanges available for currency \(self.coinSymbol!)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                    self.navigationController?.popToRootViewController(animated: true)
                    self.activityIndicator.stopAnimating()
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.availableMarkets = marketsForCoin
            self.receiveOHLCVDataFromMarket(market: marketsForCoin[0])
        }
    }
    
    func receiveOHLCVDataFromMarket(market: MarketExchange) {
        let marketDataFetcher = MarketDataFetcher()
        marketDataFetcher.getOHLCVDataForSymbol(symbol: market.symbolID, period: Period.ONEDAY) { (OHLCVArray) in
            guard let arrayOfOHLCV = OHLCVArray else {
                let alert = UIAlertController(title: "Error", message: "No market data available for currency \(self.coinSymbol!)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                    self.navigationController?.popToRootViewController(animated: true)
                    self.activityIndicator.stopAnimating()
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.currentOHLCVValues = arrayOfOHLCV
            self.activityIndicator.stopAnimating()
        }
    }
}
