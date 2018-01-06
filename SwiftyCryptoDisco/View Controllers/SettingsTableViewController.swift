//
//  SettingsTableViewController.swift
//  SwiftyCryptoDisco
//
//  Created by Mat Schmid on 2018-01-05.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import UIKit

enum BaseCurrency: String {
    case BTC = "BTC"
    case USD = "USD"
    case CAD = "CAD"
    static let allValues = [BTC, USD, CAD]
}

let kBaseCurrencyKey = "BaseCurrency"

class SettingsTableViewController: UITableViewController {
    
    let NUM_SECTIONS = 1
    let NUM_ROWS_BASECURRENCY_SECTION = 3
    var baseCurrency: BaseCurrency?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userBaseCurrency = defaults.value(forKey: kBaseCurrencyKey) {
            baseCurrency = BaseCurrency.init(rawValue: (userBaseCurrency as? String)!)
        } else {
            baseCurrency = .CAD
            defaults.set(baseCurrency?.rawValue, forKey: kBaseCurrencyKey)
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return NUM_SECTIONS
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NUM_ROWS_BASECURRENCY_SECTION
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select a base currency"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = BaseCurrency.allValues[indexPath.row].rawValue
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        if cell.textLabel?.text == baseCurrency?.rawValue {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .none {
                resetChecks(forSection: 0)
                cell.accessoryType = .checkmark
                baseCurrency = BaseCurrency.allValues[indexPath.row]
                defaults.set(baseCurrency?.rawValue, forKey: kBaseCurrencyKey)
            }
        }
    }
    
    func resetChecks(forSection section: Int) {
        for j in 0..<tableView.numberOfRows(inSection: section) {
            if let cell = tableView.cellForRow(at: NSIndexPath(row: j, section: section) as IndexPath) {
                cell.accessoryType = .none
            }
        }
    }

}
