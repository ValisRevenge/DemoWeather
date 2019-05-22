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
    
    var weatherTask: URLSessionDataTask!
    
    var currentWeather: CurrentWeatherData?
    
    var weatherForecast: ForecastSixDayData?
    
    var location:CLLocation? {
        didSet {
            weatherTask?.cancel()
            
            weatherTask = WeatherService().loadCurrentWeather(location: location!, completion: downloadWeather(weatherData:error:))
        }
    }
    
    var city: String? {
        didSet {
            weatherTask?.cancel()
            
            weatherTask = WeatherService().loadCurrentWeather(cityName: city ?? "", completion: downloadWeather(weatherData:error:))
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
    
    func downloadWeather(weatherData: CurrentWeatherData?, error:ServiceError?) {
        if let error = error {
            print(error.localizedDescription)
        }
        else {
            currentWeather = weatherData
            DispatchQueue.main.async {
                self.weatherPictureBox.image = UIImage(skyImages: .cloudy)
                self.cityLabel.text = self.currentWeather!.nameCity
                self.humidityLabel.text = "Humidity: " + String(self.currentWeather!.humidity) + " h"
                self.pressureLabel.text = "Pressure: " + String(self.currentWeather!.pressure)
                self.temperatureLabel.text = "Temp: " + String(self.currentWeather!.temp) + "'C"
                self.windLabel.text = "Wind: " + String(self.currentWeather!.windSpeed) + " m/s " + String(self.currentWeather!.windDeg) + " deg"
            }
        }
    }
    
    func downloadForecast(forecast:ForecastSixDayData?, error: ServiceError?) {
        if let error = error {
            print(error.localizedDescription)
        }
        else {
            weatherForecast = forecast
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        citySearchBar.endEditing(true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "forecastSegue" {
            let dc = segue.destination as! UINavigationController
            let vc = dc.topViewController! as! ForecastViewController
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
        weatherTask?.cancel()
        
        weatherTask = WeatherService().loadCurrentWeather(cityName: searchBar.text ?? "", completion: downloadWeather(weatherData:error:))
        //weatherTask.resume()
    }
    
}

