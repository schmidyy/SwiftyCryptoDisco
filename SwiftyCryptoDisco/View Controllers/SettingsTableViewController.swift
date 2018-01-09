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
let kSearchableCurrenciesKey = "SearchableCurrencies"

class SettingsTableViewController: UITableViewController {
    
    let NUM_SECTIONS = 2
    let NUM_ROWS_BASECURRENCY_SECTION = BaseCurrency.allValues.count
    let NUM_ROWS_SLIDER_SECTION = 1
    var baseCurrency: BaseCurrency?
    var searchableCurrencies: Int?
    
    let sliderCellID = "SliderCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sliderCell = UINib(nibName: "SliderTableViewCell", bundle: nil)
        tableView.register(sliderCell, forCellReuseIdentifier: sliderCellID)
        
        getUserBaseCurrency()
        getUserSearchableCurrencies()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return NUM_SECTIONS
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return NUM_ROWS_BASECURRENCY_SECTION
        case 1:
            return NUM_ROWS_SLIDER_SECTION
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Select a base currency"
        } else if section == 1 {
            return "Top coins on CMC to index"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell()
            cell.textLabel?.text = BaseCurrency.allValues[indexPath.row].rawValue
            cell.backgroundColor = .black
            cell.textLabel?.textColor = .white
            if cell.textLabel?.text == baseCurrency?.rawValue {
                cell.accessoryType = .checkmark
                cell.tintColor = UIColor(named: "fluoGreen")
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: sliderCellID, for: indexPath) as! SliderTableViewCell
            if searchableCurrencies == nil {
                getUserSearchableCurrencies()
            }
            cell.delegate = self
            cell.numSearchableCoinsSlider.value = Float(searchableCurrencies!)
            cell.numSearchableCoinsLabel.text = "TOP \(searchableCurrencies!)"
            return cell
        }
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
    
    //MARK: - Class Methods
    func resetChecks(forSection section: Int) {
        for j in 0..<tableView.numberOfRows(inSection: section) {
            if let cell = tableView.cellForRow(at: NSIndexPath(row: j, section: section) as IndexPath) {
                cell.accessoryType = .none
            }
        }
    }
    
    //MARK: - User Default Fetching Methods
    func getUserBaseCurrency() {
        if let userBaseCurrency = defaults.value(forKey: kBaseCurrencyKey) {
            baseCurrency = BaseCurrency.init(rawValue: (userBaseCurrency as? String)!)
        } else {
            baseCurrency = .CAD
            defaults.set(baseCurrency?.rawValue, forKey: kBaseCurrencyKey)
        }
    }
    
    func getUserSearchableCurrencies() {
        if let userSearchableCurrencies = defaults.value(forKey: kSearchableCurrenciesKey) {
            searchableCurrencies = (userSearchableCurrencies as? Int)!
        } else {
            searchableCurrencies = 100
            defaults.set(searchableCurrencies!, forKey: kSearchableCurrenciesKey)
        }
    }
}

//MARK: - SliderCellDelegate Method
extension SettingsTableViewController: SliderCellDelegate {
    func cellSliderValueDidChange(value: Int) {
        defaults.set(searchableCurrencies!, forKey: kSearchableCurrenciesKey)
        searchableCurrencies = value
    }
}
