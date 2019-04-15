//
//  WeatherDayCell.swift
//  DemoWeather
//
//  Created by Mishko on 4/12/19.
//  Copyright © 2019 322org. All rights reserved.
//

import UIKit

class WeatherDayCell: UITableViewCell {

    @IBOutlet weak var weatherImageBox: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var dayNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
