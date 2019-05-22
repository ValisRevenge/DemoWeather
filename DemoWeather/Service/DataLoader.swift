//
//  DataLoader.swift
//  DemoWeather
//
//  Created by Mishko on 4/13/19.
//  Copyright © 2019 322org. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

class DataLoader  {
    
    static let server = DataLoader()
    
    let currentWeatherUrl = "https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&units=metric&id=524901&APPID=b5ba9264d3ff44e5c0097c7aeda465a7"
    private let key = "b5ba9264d3ff44e5c0097c7aeda465a7"
    let forecastUrl = "https://api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&units=metric&id=524901&APPID=b5ba9264d3ff44e5c0097c7aeda465a7"
    
    func getWeatherByCoordinate(coordinate:CLLocation, completed:@escaping (_ dictionary:[String:Any])->Void) {
        var url:String = currentWeatherUrl.replacingOccurrences(of: "{lat}", with: coordinate.coordinate.latitude.description)
        url = url.replacingOccurrences(of: "{lon}", with: coordinate.coordinate.longitude.description)
        downloadInfo(url: url, completed: completed)
        }
    
    func getWeatherByCity(city: String, completed:@escaping (_ dictionary:[String:Any])->Void) {
        let url = currentWeatherUrl.replacingOccurrences(of: "lat={lat}&lon={lon}", with: "q="+city)
        downloadInfo(url: url, completed: completed)
    }
    
    func getForecastByCoordinate(coordinate: CLLocation, completed:@escaping (_ dictionary:[String:Any])->Void) {
        
        var url:String = forecastUrl.replacingOccurrences(of: "{lat}", with: coordinate.coordinate.latitude.description)
        url = url.replacingOccurrences(of: "{lon}", with: coordinate.coordinate.longitude.description)
        downloadInfo1(url: url, completed: completed)
    }
    
    func getForecastByCity(city:String, completed:@escaping (_ dictionary:[String:Any])->Void) {
        let url = forecastUrl.replacingOccurrences(of: "lat={lat}&lon={lon}", with: "q="+city)
        downloadInfo1(url: url, completed: completed)
    }
    
    private func downloadInfo(url:String, completed:@escaping (_ dictionary:[String:Any])->Void) {
        request(url, method: .get).validate().responseJSON {
            responce in
            switch responce.result {
            case .success:
                guard let value = responce.result.value as? [String:Any] else {return}
               // let res: CurrentWeather = try! JSONDecoder().decode(CurrentWeather.self, from: responce.data!)
                completed(value)
                //print(responce.data!)
                break
            default:
                break
            }
        }
    }
    
    private func downloadInfo1(url:String, completed:@escaping (_ dictionary:[String:Any])->Void) {
        request(url, method: .get).validate().responseJSON {
            responce in
            switch responce.result {
            case .success:
                guard let value = responce.result.value as? [String:Any] else {return}
                let res: ForecastSixDayData = try! JSONDecoder().decode(ForecastSixDayData.self, from: responce.data!)
                completed(value)
                //print(responce.data!)
                break
            default:
                break
            }
        }
    }
}
