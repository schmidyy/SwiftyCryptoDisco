
//
//  AddCoinTableViewController.swift
//  SwiftyCryptoDisco
//
//  Created by Mat Schmid on 2017-12-24.
//  Copyright © 2017 Mat Schmid. All rights reserved.
//

import UIKit

protocol AddCoinDelegate {
    func didTapCoinWithID(id: String)
}

class AddCoinTableViewController: UITableViewController, UISearchBarDelegate {
    
    let kCoinCellReuseIdentifier = "CoinCell"
    var delegate : AddCoinDelegate?
    var coins: [Currency]?
    var filteredCoins : [Currency]?
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

    @IBOutlet weak var currencySearchBar: UISearchBar!
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = CGPoint(x: tableView.frame.width / 2, y: tableView.frame.height / 2 - 56)
        self.view.addSubview(activityIndicator)
        self.activityIndicator.startAnimating()
        
        currencySearchBar.delegate = self
        let dataFetcher  = CurrencyDataFetcher()
        dataFetcher.getDataForAllCurencies { (coinArray) in
            guard let coinArray = coinArray else {
                return
            }
            //let sortedCoins = coinArray.sorted { $0.name < $1.name }
            self.coins = /*sortedCoins*/ coinArray
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if coins != nil {
            return (isSearching) ? (filteredCoins?.count)! : (coins?.count)!
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: kCoinCellReuseIdentifier) as! CoinTableViewCell
        cell.formatCellFor(coin: (isSearching) ? filteredCoins![indexPath.row] : coins![indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin = isSearching ? filteredCoins![indexPath.row] : coins![indexPath.row]
        delegate?.didTapCoinWithID(id: coin.id)
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Search Bar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (currencySearchBar.text?.isEmpty)! {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            filteredCoins = coins?.filter({ $0.name.lowercased().range(of: currencySearchBar.text!.lowercased()) != nil })
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
