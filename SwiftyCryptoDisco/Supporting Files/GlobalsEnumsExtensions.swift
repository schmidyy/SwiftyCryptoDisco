//
//  GlobalsEnumsExtensions.swift
//  SwiftyCryptoDisco
//
//  Created by Mat Schmid on 2018-02-06.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import Foundation

//MARK: - Global properties
let defaults = UserDefaults.standard

//MARK: - Enums
enum Period: String {
    case ONEHOUR = "1HRS"
    case TWELVEHOURS = "12HRS"
    case ONEDAY = "1DAY"
    case ONEWEEK = "7DAY"
    case ONEMONTH = "1MTH"
    case ONEYEAR = "1YRS"
    static let allValues = [ONEHOUR, TWELVEHOURS, ONEDAY, ONEWEEK, ONEMONTH, ONEYEAR]
}

//MARK: - Extensions
extension NSNumber {
    var formattedCurrencyString: String? {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        return formatter.string(from: self)
    }
}
