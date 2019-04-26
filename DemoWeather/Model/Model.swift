//
//  Model.swift
//  DemoWeather
//
//  Created by Mishko on 4/25/19.
//  Copyright © 2019 322org. All rights reserved.
//

import Foundation
import CoreLocation

struct Weather: Decodable {
    var date:Date?
    var coordinate: CLLocation?
    var type: String
    var description: String
    var temp: Double
    var pressure: Double
    var humidity: Double
    var visibility: Int
    
    var windSpeed:Double
    var windDeg:Double
    
    var country: String
    var sunrise: Int
    var sunset: Int
    var nameCity: String
    
    enum CodingKeys: String, CodingKey {
        case coord
        case main
        case visibility
        case clouds
        case name
        case sys
        case weather
        case wind
        case dt
    }
    
    enum CoordCodingKeys: String, CodingKey {
        case lon
        case lat
    }
    
    enum WeatherCodingKeys: String, CodingKey {
        case description
        case main
        case icon
    }
    
    enum MainCodingKeys: String, CodingKey {
        case temp
        case pressure
        case humidity
    }
    
    enum SysCodingKeys: String, CodingKey {
        case country
        case sunrise
        case sunset
    }
    
    enum WindCodingKeys: String, CodingKey {
        case speed
        case deg
    }
    
//    init(dictionary:[String:Any]) {
//        if let point = dictionary["coord"] as? CLLocation {
//            coordinate = point
//        }
//        type = dictionary["type"] as? String ?? ""
//        description = dictionary["description"] as? String ?? ""
//        temp = dictionary["temp"] as? Double ?? 0.0
//        pressure = dictionary["pressure"] as? Double ?? 0.0
//        humidity = dictionary["humidity"] as? Double ?? 0.0
//        visibility = dictionary["visibility"] as? Int ?? 0
//        country = dictionary["country"] as? String ?? ""
//        sunrise = dictionary["sunrise"] as? Int ?? 0
//        sunset = dictionary["sunset"] as? Int ?? 0
//        nameCity = dictionary["name"] as? String ?? ""
//    }
    
    //unwrape JSON
    init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.visibility = try container.decode(Int.self, forKey: .visibility)
        self.nameCity = try container.decode(String.self, forKey: .name)
        let dt = try container.decode(Double.self, forKey: .dt)
        date = Date(timeIntervalSinceReferenceDate: dt)
        
        let coordContainer = try container.nestedContainer(keyedBy: CoordCodingKeys.self, forKey: .coord)
        let lat = try coordContainer.decode(Double.self, forKey: .lat)
        let lon = try coordContainer.decode(Double.self, forKey: .lon)
        self.coordinate = CLLocation(latitude: lat, longitude: lon)
        
        let weatherContainer = try container.nestedContainer(keyedBy: WeatherCodingKeys.self, forKey: .weather)
        self.type = try weatherContainer.decode(String.self, forKey: .main)
        self.description = try weatherContainer.decode(String.self, forKey: .description)
        
        let mainContainer = try container.nestedContainer(keyedBy: MainCodingKeys.self, forKey: .main)
        self.temp = try mainContainer.decode(Double.self, forKey: .temp)
        self.pressure = try mainContainer.decode(Double.self, forKey: .pressure)
        self.humidity = try mainContainer.decode(Double.self, forKey: .humidity)
        
        let sysContainer = try container.nestedContainer(keyedBy: SysCodingKeys.self, forKey: .sys)
        self.country = try sysContainer.decode(String.self, forKey: .country)
        self.sunrise = try sysContainer.decode(Int.self, forKey: .sunrise)
        self.sunset = try sysContainer.decode(Int.self, forKey: .sunset)
        
        let windContainer = try container.nestedContainer(keyedBy: WindCodingKeys.self, forKey: .wind)
        self.windDeg = try windContainer.decode(Double.self, forKey: .deg)
        self.windSpeed = try windContainer.decode(Double.self, forKey: .speed)
        
    }
    
}
