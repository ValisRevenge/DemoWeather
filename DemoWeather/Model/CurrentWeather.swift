//
//  Model.swift
//  DemoWeather
//
//  Created by Mishko on 4/25/19.
//  Copyright © 2019 322org. All rights reserved.
//

import Foundation
import CoreLocation

struct CurrentWeatherData: Decodable {
    
    var date:Date?
    var coordinate: CLLocation?
    var type: String = ""
    var description: String = ""
    var temp: Double = 0
    var pressure: Double = 0
    var humidity: Double = 0
    var visibility: Int = 0
    
    var windSpeed:Double = 0
    var windDeg:Double = 0
    
    var country: String = ""
    var sunrise: Date?
    var sunset: Date?
    var nameCity: String = ""
    
    var clouds: Int = 0
    
   private enum CodingKeys: String, CodingKey {
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
    
    private enum NestedCodingKeys: String, CodingKey {
        case lon = "lon"
        case lat = "lat"
        case description = "description"
        case main = "main"
        case icon = "icon"
        case temp = "temp"
        case pressure = "pressure"
        case humidity = "humidity"
        case country = "country"
        case sunrise = "sunrise"
        case sunset = "sunset"
        case speed = "speed"
        case deg = "deg"
        case all = "all"
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
        self.visibility = (try? container.decode(Int.self, forKey: .visibility)) ?? 0
        self.nameCity = (try? container.decode(String.self, forKey: .name)) ?? ""
        let dt = try container.decode(Double.self, forKey: .dt)
        date = Date(timeIntervalSince1970: dt)
        
        if let coordContainer = try? container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .coord) {
            let lat = try coordContainer.decode(Double.self, forKey: .lat)
            let lon = try coordContainer.decode(Double.self, forKey: .lon)
            self.coordinate = CLLocation(latitude: lat, longitude: lon)
        }
        
        if let mainContainer = try? container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .main) {
            self.temp = try mainContainer.decode(Double.self, forKey: .temp)
            self.pressure = try mainContainer.decode(Double.self, forKey: .pressure)
            self.humidity = try mainContainer.decode(Double.self, forKey: .humidity)
        }
        
        if let sysContainer = try? container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .sys) {
            self.country = (try? sysContainer.decode(String.self, forKey: .country)) ?? ""
            if let sunrise = try? sysContainer.decode(Double.self, forKey: .sunrise) {
                self.sunrise = Date(timeIntervalSince1970: sunrise)
            }
            if let sunset = try? sysContainer.decode(Double.self, forKey: .sunset) {
                self.sunset = Date(timeIntervalSince1970: sunset)
            }
        }
        
        let windContainer = try container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .wind)
        self.windDeg = try windContainer.decode(Double.self, forKey: .deg)
        self.windSpeed = try windContainer.decode(Double.self, forKey: .speed)
        
        let cloudsContainer = try container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .clouds)
        self.clouds = try cloudsContainer.decode(Int.self, forKey: .all)
        // unwrap array of weather
        var weatherContainer = try container.nestedUnkeyedContainer(forKey: .weather)
        while !weatherContainer.isAtEnd {
            let cont = try weatherContainer.nestedContainer(keyedBy: NestedCodingKeys.self)
            self.type = try cont.decode(String.self, forKey: .main)
            self.description = try cont.decode(String.self, forKey: .description)
        }
        
    }
    
}
