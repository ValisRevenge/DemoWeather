//
//  Forecast.swift
//  DemoWeather
//
//  Created by Mishko on 4/27/19.
//  Copyright © 2019 322org. All rights reserved.
//

import Foundation
import CoreLocation

struct ForecastSixDay: Decodable {
    
    var forecast: [CurrentWeather]?
    
    var location: CLLocation?
    
    var cityName: String?
    
    var country: String?
    
    private enum CodingKeys: String, CodingKey {
        case list
        case city
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        forecast = [CurrentWeather]()
        var currentContainer = try container.nestedUnkeyedContainer(forKey: .list)
        while !currentContainer.isAtEnd {
            let cont = try currentContainer.decode(CurrentWeather.self)
            forecast!.append(cont)
        }
        cityName = ""
    }
    
}
