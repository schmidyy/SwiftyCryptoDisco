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

class CurrencyTableViewController: UITableViewController {
    
    let defaultCurrencies = ["bitcoin", "ethereum"/*, "bitcoin-cash", "ripple", "litecoin", "iota", "cardano", "dash", "nem", "monero"*/]
    let kCoinCellReuseIdentifier = "CoinCell"
    var refreshController: UIRefreshControl?
    var delegate : CurrencyTableViewDelegate?
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshController()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaultCurrencies.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: kCoinCellReuseIdentifier) as! CoinTableViewCell
        cell.formatCellFor(currency: defaultCurrencies[indexPath.row])
        return cell
    }
    
    //MARK: - Class methods
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
}
