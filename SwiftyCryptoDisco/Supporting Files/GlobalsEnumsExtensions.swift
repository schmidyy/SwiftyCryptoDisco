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

extension String {
    func getStringRepresentableFromISO8601String() -> String {
        if (!self.isEmpty) {
            let dateSplit = self.split(separator: "-")
            let timeSeperatorSplit = dateSplit[dateSplit.count - 1].split(separator: "T")
            let timeSplit = timeSeperatorSplit[timeSeperatorSplit.count - 1].split(separator: ":")
            
            let year = dateSplit[0]
            let month = dateSplit[1]
            let day = timeSeperatorSplit[0]
            let hour = timeSplit[0]
            let minute = timeSplit[1]
            
            var dateComponents = DateComponents()
            dateComponents.year = Int(year)
            dateComponents.month = Int(month)
            dateComponents.day = Int(day)
            dateComponents.hour = Int(hour)
            dateComponents.minute = Int(minute)
            let date = Calendar.current.date(from: dateComponents)!
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d h:mm"
            let dateString = formatter.string(from: date)
            return dateString
        }
        return ""
    }
}
