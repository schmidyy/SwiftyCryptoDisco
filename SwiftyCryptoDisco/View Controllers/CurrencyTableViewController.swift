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

class CurrencyTableViewController: UITableViewController, AddCoinDelegate {
    
    var defaultCurrencies: [String]?
    let kCoinCellReuseIdentifier = "CoinCell"
    let kDefaultCurrencyNameArrayKey = "CurrencyNames"
    var refreshController: UIRefreshControl?
    var delegate : CurrencyTableViewDelegate?
    var addCoinVC: AddCoinTableViewController!
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshController()
        
        if let userSavedCurrencies = defaults.value(forKey: kDefaultCurrencyNameArrayKey) {
            defaultCurrencies = userSavedCurrencies as? [String]
        } else {
            defaultCurrencies = ["bitcoin", "ethereum"]
            defaults.set(defaultCurrencies, forKey: kDefaultCurrencyNameArrayKey)
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addVC" {
            addCoinVC = segue.destination as! AddCoinTableViewController
            addCoinVC.delegate = self
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaultCurrencies!.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: kCoinCellReuseIdentifier) as! CoinTableViewCell
        cell.formatCellFor(currencyName: defaultCurrencies![indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (action: UITableViewRowAction, indexPath:IndexPath) in
            self.defaultCurrencies!.remove(at: indexPath.row)
            defaults.set(self.defaultCurrencies, forKey: self.kDefaultCurrencyNameArrayKey)
            self.tableView.reloadData()
        }
        deleteAction.backgroundColor = UIColor(named: "flatRed")
        
        let watchAction = UITableViewRowAction(style: .normal, title: "Watch") { (action: UITableViewRowAction, indexPath:IndexPath) in
            //TODO: add watch functionality
        }
        watchAction.backgroundColor = UIColor(named: "flatBlue")
        
        return [deleteAction, watchAction]
    }
    
    //MARK: - Class methods
    func fetchDefaultCurrencyData() {
        var localDefaultCoins: [Currency] = []
        let dataFetcher = CurrencyDataFetcher()
        for currencyID in defaultCurrencies! {
            dataFetcher.getDataForCurrency(currency: currencyID, completion: { (fetchedCurrency) in
                guard let newCurrency = fetchedCurrency else {
                    print("Error: Unable to fetch default currency data.")
                    return
                }
                localDefaultCoins.append(newCurrency)
            })
        }
    }
    
    func setupRefreshController() {
        refreshController = UIRefreshControl()
        refreshController?.tintColor = UIColor(named: "flatBlue")
        refreshController?.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshController
        } else {
            tableView.addSubview(refreshController!)
        }
    }
    
    func handleRefresh(_ sender: Any) {
        tableView.reloadData()
        delegate?.didTapRefreshButton()
        refreshController?.endRefreshing()
    }
    
    //MARK: - AddCoinDelegate
    func didTapCoinWithID(id: String) {
        if !(defaultCurrencies?.contains(id))! {
            defaultCurrencies!.append(id)
            defaults.set(defaultCurrencies, forKey: kDefaultCurrencyNameArrayKey)
            tableView.reloadData()
        } else {
            let alert = UIAlertController(title: "Error", message: "Currency already being monitored", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
}
