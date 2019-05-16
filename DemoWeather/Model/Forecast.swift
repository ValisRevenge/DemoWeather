//
//  Forecast.swift
//  DemoWeather
//
//  Created by Mishko on 4/27/19.
//  Copyright © 2019 322org. All rights reserved.
//

import Foundation
import CoreLocation

struct ForecastSixDayData: Decodable {
    
    var forecast: [CurrentWeatherData]?
    
    var location: CLLocation?
    
    var cityName: String?
    
    var country: String?
    
    private enum CodingKeys: String, CodingKey {
        case list
        case city
    }
    
    private enum NestedCodingKeys: String, CodingKey {
        case coord = "coord"
        case lat = "lat"
        case lon = "lon"
        case country = "country"
        case name = "name"
    }
    // unwrap JSON
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        forecast = [CurrentWeatherData]()
        var currentContainer = try container.nestedUnkeyedContainer(forKey: .list)
        while !currentContainer.isAtEnd {
            let cont = try currentContainer.decode(CurrentWeatherData.self)
            forecast!.append(cont)
        }
        
        let cityContainer = try container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .city)
        self.cityName = try cityContainer.decode(String.self, forKey: .name)
        self.country = try cityContainer.decode(String.self, forKey: .country)
        
        let coordContainer = try cityContainer.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .coord)
        let lat = try coordContainer.decode(Double.self, forKey: .lat)
        let lon = try coordContainer.decode(Double.self, forKey: .lon)
        self.location = CLLocation(latitude: lat, longitude: lon)
    }
    
}
