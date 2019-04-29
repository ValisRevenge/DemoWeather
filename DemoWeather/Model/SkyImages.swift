//
//  SkyImages.swift
//  DemoWeather
//
//  Created by Mishko on 4/29/19.
//  Copyright © 2019 322org. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    enum SkyImages: String {
        case rain = "rain"
        case mist = "mist"
        case bright_sunny = "bright_shunny"
        case snow = "snow"
        case cloudy = "cloudy"
        
        static let values = [rain, mist, bright_sunny, snow, cloudy]
    }
    
    convenience init!(skyImages: SkyImages) {
        self.init(named: skyImages.rawValue)
    }
    
}
