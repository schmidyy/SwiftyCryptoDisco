//
//  ContainerViewController.swift
//  SwiftyCryptoDisco
//
//  Created by Mat Schmid on 2017-12-22.
//  Copyright © 2017 Mat Schmid. All rights reserved.
//

import UIKit
import Alamofire

class ContainerViewController: UIViewController, CurrencyTableViewDelegate {

    @IBOutlet weak var refreshDateLabel: UILabel!
    @IBOutlet weak var addCoinButton: UIButton!
    
    var mainNavigationController: UINavigationController!
    var currencyTableViewController: CurrencyTableViewController!
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addCoinButton.layer.cornerRadius = addCoinButton.frame.width / 2

        refreshDate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CryptoVC" {
            mainNavigationController = segue.destination as! UINavigationController
            currencyTableViewController = mainNavigationController.childViewControllers.first as! CurrencyTableViewController!
            currencyTableViewController.delegate = self
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Supporting Class Methods
    func refreshDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        refreshDateLabel.text = dateString
    }
    
    //MARK: - Event Handlers
    @IBAction func addCoinButtonTapped(_ sender: UIButton) {
        let addCoinVC = storyboard?.instantiateViewController(withIdentifier: "addCoinVC") as! AddCoinTableViewController
        addCoinVC.delegate = currencyTableViewController
        mainNavigationController.pushViewController(addCoinVC, animated: true)
    }
    
    // MARK: - CurrencyTableViewDelegate
    func didTapRefreshButton() {
        refreshDate()
    }
}
