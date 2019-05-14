//
//  ViewController.swift
//  DemoWeather
//
//  Created by Mishko on 4/12/19.
//  Copyright © 2019 322org. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

//
class ViewController: UIViewController {
    
    @IBOutlet weak var weatherPictureBox: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var windLabel: UILabel!
    
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var citySearchBar: UISearchBar!
    
    var locationManager: CLLocationManager!
    
    var loader:DataLoader = DataLoader()
    
    var weatherDictionary:[String:Any]? {
        didSet {
            readData(dictionary: weatherDictionary)
        }
    }
    var forecastDictionary:[String:Any]?
    
    var location:CLLocation? {
        didSet {
            if let point = location {
                loader.getWeatherByCoordinate(coordinate: point, completed: downloadWeather)
                loader.getForecastByCoordinate(coordinate: point, completed: downloadForecast)
            }
        }
    }
    
    var city:String = "Dnipropropetrovsk" {
        didSet {
            loader.getWeatherByCity(city: city, completed: downloadWeather)
            loader.getForecastByCity(city: city, completed: downloadForecast)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        self.citySearchBar.delegate = self
        
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func downloadWeather(dictionary:[String:Any]) {
        weatherDictionary = dictionary
    }
    
    @objc func downloadForecast(dictionary:[String:Any]) {
        forecastDictionary = dictionary
    }
    
    func readData(dictionary:[String:Any]?) {
        guard let info = dictionary else {return}
        if let weather = info["weather"] as? [[String:Any]] {
            let imageType = weather[0]["main"] as! String
            switch imageType {
            case "Clear":
                weatherPictureBox.image = #imageLiteral(resourceName: "bright_sunny")
                break
            case "Snow":
                weatherPictureBox.image = #imageLiteral(resourceName: "snow")
                break
            case "Clouds":
                weatherPictureBox.image = #imageLiteral(resourceName: "cloudy")
                break
            case "Mist":
                weatherPictureBox.image = #imageLiteral(resourceName: "mist")
                break
            case "Rain":
                weatherPictureBox.image = #imageLiteral(resourceName: "rain")
                break
            default:
                weatherPictureBox.image = #imageLiteral(resourceName: "cloudy")
                break
            }
            
        }
        if let weather = info["main"] as? [String:Any] {
            temperatureLabel.text = String(weather["temp"] as? Double ?? 0) + "'C"
            pressureLabel.text = "pressure: " + (String(weather["pressure"] as? Double ?? 0))
            humidityLabel.text = "humidity: " + (String(weather["humidity"] as? Double ?? 0)) + " %"
        }
        if let sysInfo = info["name"] as? String {
            cityLabel.text = sysInfo
        }
        let wind = info["wind"] as! [String:Any]
        windLabel.text = "wind: " +  String((wind["speed"] as? Double ?? 0)) + " m/s, deg: " + String(wind["deg"] as? Double ?? 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        citySearchBar.endEditing(true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "forecastSegue" {
            let dc = segue.destination as! UINavigationController
            let vc = dc.topViewController! as! WeekWeatherViewController
            vc.forecastDictionary = forecastDictionary
            vc.city = cityLabel.text ?? ""
        }
    }

}

extension ViewController: CLLocationManagerDelegate, UISearchBarDelegate {
    
    //Mark: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = manager.location ?? nil 
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.city = searchBar.text ?? ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarTextDidEndEditing(citySearchBar)
    }
    
}

