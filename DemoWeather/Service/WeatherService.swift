//
//  WeatherService.swift
//  DemoWeather
//
//  Created by Mishko on 5/18/19.
//  Copyright © 2019 322org. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

final class WeatherService {
    
    private let client = WebClient(url: "https://api.openweathermap.org")
    
    private let appKey = "b5ba9264d3ff44e5c0097c7aeda465a7"
    
    //let forecastUrl = "https://api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&units=metric&id=524901&APPID=b5ba9264d3ff44e5c0097c7aeda465a7"
    
    func loadCurrentWeather(location: CLLocation, completion: @escaping(CurrentWeatherData?, ServiceError?)-> ()) -> URLSessionDataTask? {
        
        let params: [String:Any] = ["lat": location.coordinate.latitude, "lon":location.coordinate.longitude, "units":"metric", "appid":appKey]
        return client.load(path: "/data/2.5/weather", httpMethod: .get, params: params, completion: {
            result, error in
            var currentWeather:CurrentWeatherData?
            if let dictionary = result as? Data {
                currentWeather = try? JSONDecoder().decode(CurrentWeatherData.self, from: dictionary)
            }
            completion(currentWeather, error)
        })
    }
    
    func loadCurrentWeather(cityName: String, completion: @escaping(CurrentWeatherData?, ServiceError?)-> ()) -> URLSessionDataTask? {
        let params: [String:Any] = ["q": cityName,  "units":"metric", "appid":appKey]
        return client.load(path: "/data/2.5/weather", httpMethod: .get, params: params, completion: {
            result, error in
            var currentWeather:CurrentWeatherData?
            if let dictionary = result as? Data {
                currentWeather = try? JSONDecoder().decode(CurrentWeatherData.self, from: dictionary)
            }
            completion(currentWeather, error)
        })
    }
    
    func loadSixDayForecast(location: CLLocation, completion: @escaping(ForecastSixDayData?, ServiceError?)-> ()) -> URLSessionDataTask? {
        let params: [String:Any] = ["lat":location.coordinate.latitude, "lon":location.coordinate.longitude, "units":"metric", "appid":appKey]
        return client.load(path: "/data/2.5/forecast", httpMethod: .get, params: params, completion: {
            result, error in
            let dictionary = result as? Data
            let forecast = try? JSONDecoder().decode(ForecastSixDayData.self, from: dictionary!)
            completion(forecast, error)
        })
    }
    
    func loadSixDayForecast(cityName: String, completion: @escaping(ForecastSixDayData?, ServiceError?)-> ()) -> URLSessionDataTask? {
        let params: [String:Any] = ["q": cityName,  "units":"metric", "appid":appKey]
        return client.load(path: "/data/2.5/forecast", httpMethod: .get, params: params, completion: {
            result, error in
            let dictionary = result as? Data
            let forecast = try? JSONDecoder().decode(ForecastSixDayData.self, from: dictionary!)
            completion(forecast, error)        })
    }
    
    func loadWeatherIcon(iconName: String, completion: @escaping(UIImage?, ServiceError?)-> ()) -> URLSessionDataTask? {
        return client.load(path: "/img/w/" + iconName, httpMethod: .get, params: [:], completion: {
            result, error in
            var icon:UIImage?
            if let data = result as? Data {
                icon = UIImage(data: data)
            }
            completion(icon, error)
        })
    }
    
}
