//
//  CoinDataViewController.swift
//  SwiftyCryptoDisco
//
//  Created by Mat Schmid on 2018-01-09.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import UIKit

class CoinDataViewController: UIViewController {
    
    let kOHLCVCellReuseIdentifier = "OHLCVCell"
    let kCoinCellReuseIdentifier = "CoinCell"
    var coinSymbol: String?
    var coinName: String?
    var availableMarkets: [MarketExchange]?
    var currentOHLCVValues: [OHLCV]?
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var selectedTimeSpan: Period?
    
    @IBOutlet weak var ohlcvTableView: UITableView!
    @IBOutlet weak var coinTableView: UITableView!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var timeSpanStackView: UIStackView!
    @IBOutlet weak var selectedTimeSpanView: UIView!
    @IBOutlet weak var selectedTimeSpanXConstraint: NSLayoutConstraint!
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarTitle()
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2 - 78)
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        sellButton.layer.cornerRadius = 4
        buyButton.layer.cornerRadius = 4
        selectedTimeSpanView.layer.cornerRadius = 1
        
        ohlcvTableView.dataSource = self
        ohlcvTableView.delegate = self
        coinTableView.dataSource = self
        coinTableView.delegate = self
        coinTableView.isScrollEnabled = false
        selectedTimeSpan = Period.ONEDAY
        //selectedTimeSpanView.centerXAnchor.constraint(equalTo: (timeSpanStackView.arrangedSubviews[0] as! UIButton).centerXAnchor).isActive = true
        setViewsToHidden(hidden: true)
        
        receiveMarketDataForSymbol(coinSymbol: coinSymbol!)
    }
    
    //MARK: - Setup methods
    func setupNavBarTitle() {
        var baseCurrency: BaseCurrency
        if let fetchedBaseCurrency = defaults.object(forKey: kBaseCurrencyKey) {
            baseCurrency = BaseCurrency(rawValue: (fetchedBaseCurrency as? String)!)!
        } else {
            baseCurrency = BaseCurrency.CAD
        }
        self.title = "\(coinSymbol!)/\(baseCurrency.rawValue)"
    }
    
    func setViewsToHidden(hidden: Bool) {
        self.ohlcvTableView.isHidden = hidden
        self.coinTableView.isHidden = hidden
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
        marketDataFetcher.getOHLCVDataForSymbol(symbol: market.symbolID, period: selectedTimeSpan!) { (OHLCVArray) in
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
            self.ohlcvTableView.reloadData()
            self.coinTableView.reloadData()
            self.setViewsToHidden(hidden: false)
        }
    }
    
    //MARK: - Event Handlers
    @IBAction func didTapTimeSpanButton(_ sender: UIButton) {
        selectedTimeSpanXConstraint.isActive = false
        selectedTimeSpanXConstraint = selectedTimeSpanView.centerXAnchor.constraint(equalTo: (timeSpanStackView.viewWithTag(sender.tag) as! UIButton).centerXAnchor)
        selectedTimeSpanXConstraint.isActive = true
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        selectedTimeSpan = Period.allValues[sender.tag - 1]
        ohlcvTableView.isHidden = true
        activityIndicator.startAnimating()
        receiveOHLCVDataFromMarket(market: availableMarkets![0])
    }
    
}

//MARK: - TableView Delegata & Data Source Methods
extension CoinDataViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ohlcvTableView {
            if currentOHLCVValues != nil {
                return (currentOHLCVValues?.count)!
            }
            return 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ohlcvTableView {
            let cell = ohlcvTableView.dequeueReusableCell(withIdentifier: kOHLCVCellReuseIdentifier, for: indexPath) as! OHLCVTableViewCell
            cell.formatCellWithOHLCV(ohlcv: currentOHLCVValues![indexPath.row])
            return cell
        } else {
            let cell = coinTableView.dequeueReusableCell(withIdentifier: kCoinCellReuseIdentifier) as! CoinTableViewCell
            cell.formatCellFor(currencyName: coinName!)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == ohlcvTableView {
            return 72
        } else {
            return 66
        }
    }
}
