//
//  ContainerViewController.swift
//  SwiftyCryptoDisco
//
//  Created by Mat Schmid on 2017-12-22.
//  Copyright © 2017 Mat Schmid. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, UINavigationControllerDelegate , CurrencyTableViewDelegate {

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
            mainNavigationController.delegate = self
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
    
    //MARK: - CurrencyTableViewDelegate
    func didTapRefreshButton() {
        refreshDate()
    }
    
    //MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let title = viewController.title {
            if title != "Crypto Disco" {
                addCoinButton.isHidden = true
            } else {
                addCoinButton.isHidden = false
            }
        }
    }
}
