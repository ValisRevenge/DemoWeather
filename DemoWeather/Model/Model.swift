//
//  Model.swift
//  DemoWeather
//
//  Created by Mishko on 4/25/19.
//  Copyright © 2019 322org. All rights reserved.
//

import Foundation
import CoreLocation

struct Wind {
    var speed: Double
    var degree: Double
}

struct Weather {
    var coordinate: CLLocation?
    var type: String = ""
    var description: String = ""
    var temperature: Double = 0.0
    var pressure: Double = 0.0
    var humidity: Double = 0.0
    var visibility: Int = 0
    var wind: Wind = Wind(speed: 0.0, degree: 0.0)
    var cloudsPersentage: Double = 0
    var country: String = ""
    var sunrise: Int = 0
    var sunset: Int = 0
    var nameCity: String = ""
    
    init(dictionary:[String:Any]) {
        if let point = dictionary["coord"] as? CLLocation {
            coordinate = point
        }
        type = dictionary["type"] as? String ?? ""
        description = dictionary["description"] as? String ?? ""
        temperature = dictionary["temp"] as? Double ?? 0.0
        pressure = dictionary["pressure"] as? Double ?? 0.0
        humidity = dictionary["humidity"] as? Double ?? 0.0
        visibility = dictionary["visibility"] as? Int ?? 0
        wind = dictionary["temp"] as? Wind ?? Wind(speed: 0.0, degree: 0.0)
        cloudsPersentage = dictionary["clouds"] as? Double ?? 0.0
        country = dictionary["country"] as? String ?? ""
        sunrise = dictionary["sunrise"] as? Int ?? 0
        sunset = dictionary["sunset"] as? Int ?? 0
        nameCity = dictionary["name"] as? String ?? ""
    }
    
}
