//
//  OHLCVTableViewCell.swift
//  SwiftyCryptoDisco
//
//  Created by Mat Schmid on 2018-02-06.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import UIKit

class OHLCVTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var closeLabel: UILabel!
    
    func formatCellWithOHLCV(ohlcv: OHLCV) {
        timeLabel.text = getStringRepresentableFromISO8601String(iso: ohlcv.timePeriodStart)
        volumeLabel.text = String(format: "%.4f", ohlcv.volume.floatValue)
        openLabel.text = String(format: "%.f", ohlcv.priceOpen.floatValue)
        highLabel.text = String(format: "%.f", ohlcv.priceHigh.floatValue)
        lowLabel.text = String(format: "%.f", ohlcv.priceLow.floatValue)
        closeLabel.text = String(format: "%.f", ohlcv.priceClose.floatValue)
    }
    
    func getStringRepresentableFromISO8601String(iso: String) -> String {
        if (!iso.isEmpty) {
            let dateSplit = iso.split(separator: "-")
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
