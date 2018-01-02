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
    
    var defaultCurrencies = ["bitcoin", "ethereum"]
    let kCoinCellReuseIdentifier = "CoinCell"
    var refreshController: UIRefreshControl?
    var delegate : CurrencyTableViewDelegate?
    var addCoinVC: AddCoinTableViewController!
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshController()
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
        return defaultCurrencies.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: kCoinCellReuseIdentifier) as! CoinTableViewCell
        cell.formatCellFor(currencyName: defaultCurrencies[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (action: UITableViewRowAction, indexPath:IndexPath) in
            self.defaultCurrencies.remove(at: indexPath.row)
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
        if !defaultCurrencies.contains(id) {
            defaultCurrencies.append(id)
            tableView.reloadData()
        } else {
            // coin already in list
        }
    }
}
