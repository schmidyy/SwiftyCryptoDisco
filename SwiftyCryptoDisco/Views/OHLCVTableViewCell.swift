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
        timeLabel.text = ohlcv.timePeriodStart.getStringRepresentableFromISO8601String()
        volumeLabel.text = String(format: "%.4f", ohlcv.volume.floatValue)
        openLabel.text = String(format: "%.f", ohlcv.priceOpen.floatValue)
        highLabel.text = String(format: "%.f", ohlcv.priceHigh.floatValue)
        lowLabel.text = String(format: "%.f", ohlcv.priceLow.floatValue)
        closeLabel.text = String(format: "%.f", ohlcv.priceClose.floatValue)
    }
}
