//
//  AddCoinTableViewController.swift
//  SwiftyCryptoDisco
//
//  Created by Mat Schmid on 2017-12-24.
//  Copyright © 2017 Mat Schmid. All rights reserved.
//

import UIKit

class AddCoinTableViewController: UITableViewController {
    
    let kCoinCellReuseIdentifier = "CoinCell"
    
    var coins: [Currency]?

    override func viewDidLoad() {
        super.viewDidLoad()
        let dataFetcher  = CurrencyDataFetcher()
        dataFetcher.getDataForAllCurencies { (coinArray) in
            guard let coinArray = coinArray else {
                return
            }
            self.coins = coinArray
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if coins != nil {
            return (coins?.count)!
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: kCoinCellReuseIdentifier) as! CoinTableViewCell
        cell.formatCellFor(currency: coins![indexPath.row])
        return cell
    }
}
