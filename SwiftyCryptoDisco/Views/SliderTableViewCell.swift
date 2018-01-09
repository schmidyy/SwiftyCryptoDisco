//
//  SliderTableViewCell.swift
//  SwiftyCryptoDisco
//
//  Created by Mat Schmid on 2018-01-08.
//  Copyright © 2018 Mat Schmid. All rights reserved.
//

import UIKit

protocol SliderCellDelegate: class {
    func cellSliderValueDidChange(value: Int)
}

class SliderTableViewCell: UITableViewCell {

    @IBOutlet weak var numSearchableCoinsLabel: UILabel!
    @IBOutlet weak var numSearchableCoinsSlider: UISlider!
    
    var delegate: SliderCellDelegate?

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let step: Float = 5.0
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        numSearchableCoinsLabel.text = "TOP \(Int(roundedValue))"
        delegate?.cellSliderValueDidChange(value: Int(roundedValue))
    }
}
