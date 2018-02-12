//
//  CurrencyTableViewController.swift
//  SwiftyCryptoDisco
//
//  Created by Mat Schmid on 2017-12-22.
//  Copyright © 2017 Mat Schmid. All rights reserved.
//

import UIKit

protocol CurrencyTableViewDelegate: class {
    func didTapRefreshButton()
}

class CurrencyTableViewController: UITableViewController, AddCoinDelegate, SettingsDelegate {
    
    var watchedCurrencies: [String]?
    let kCoinCellReuseIdentifier = "CoinCell"
    let kDefaultCurrencyNameArrayKey = "CurrencyNames"
    var refreshController: UIRefreshControl?
    var delegate : CurrencyTableViewDelegate?
    var addCoinVC: AddCoinTableViewController!
    var settingsVC: SettingsTableViewController!
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshController()
        checkForConnection()
        
        if let userSavedCurrencies = defaults.value(forKey: kDefaultCurrencyNameArrayKey) {
            watchedCurrencies = userSavedCurrencies as? [String]
        } else {
            watchedCurrencies = ["bitcoin", "ethereum"]
            defaults.set(watchedCurrencies, forKey: kDefaultCurrencyNameArrayKey)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addVC" {
            addCoinVC = segue.destination as! AddCoinTableViewController
            addCoinVC.delegate = self
        } else if segue.identifier == "settingsVC" {
            settingsVC = segue.destination as! SettingsTableViewController
            settingsVC.delegate = self
        }
    }
    
    //MARK: - Class methods
    func checkForConnection() {
        tableView.isHidden = true
        if ConnectionManager.isConnectedToInternet() {
            tableView.isHidden = false
        } else {
            let alert = UIAlertController(title: "Error", message: "No internet connection detected. Please refresh the app when an internet connection is available.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func setupRefreshController() {
        refreshController = UIRefreshControl()
        refreshController?.tintColor = UIColor(named: "flatBlue")
        refreshController?.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        tableView.refreshControl = refreshController
    }
    
    func handleRefresh(_ sender: Any?) {
        checkForConnection()
        tableView.reloadData()
        delegate?.didTapRefreshButton()
        refreshController?.endRefreshing()
    }

    // MARK: - Table view data source & delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchedCurrencies!.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: kCoinCellReuseIdentifier) as! CoinTableViewCell
        cell.formatCellFor(currencyName: watchedCurrencies![indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (action: UITableViewRowAction, indexPath:IndexPath) in
            self.watchedCurrencies!.remove(at: indexPath.row)
            defaults.set(self.watchedCurrencies, forKey: self.kDefaultCurrencyNameArrayKey)
            self.tableView.reloadData()
        }
        deleteAction.backgroundColor = UIColor(named: "flatRed")
        
        let watchAction = UITableViewRowAction(style: .normal, title: "Share") { (action: UITableViewRowAction, indexPath:IndexPath) in
            //TODO: add watch functionality
        }
        watchAction.backgroundColor = UIColor(named: "flatBlue")
        return [deleteAction, watchAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coinDataVC = storyboard?.instantiateViewController(withIdentifier: "coinDataVC") as! CoinDataViewController
        let cell = tableView.cellForRow(at: indexPath) as! CoinTableViewCell
        coinDataVC.coinSymbol = cell.coinSymbol!
        coinDataVC.coinName = cell.coinName!
        navigationController?.pushViewController(coinDataVC, animated: true)
    }
    
    //MARK: - AddCoinDelegate
    func didTapCoinWithID(id: String) {
        if !(watchedCurrencies?.contains(id))! {
            watchedCurrencies!.append(id)
            defaults.set(watchedCurrencies, forKey: kDefaultCurrencyNameArrayKey)
            tableView.reloadData()
        } else {
            let alert = UIAlertController(title: "Error", message: "Currency already being monitored", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - SettingsDelegate
    func didChangeDefaultCurrency() {
        handleRefresh(nil)
    }
}
