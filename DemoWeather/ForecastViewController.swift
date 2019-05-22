//
//  WeekWeatherViewController.swift
//  DemoWeather
//
//  Created by Mishko on 4/12/19.
//  Copyright © 2019 322org. All rights reserved.
//

import UIKit
import Foundation

class ForecastViewController: UIViewController {

    var forecastData: ForecastSixDayData?
    
    var tableSectionsCount = 0
    
    var temperatureArray:[Double] = []
    
    var city:String = ""

    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    @IBOutlet weak var weatherTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherTable.dataSource = self
        //weatherTable.delegate = self
        
        self.weatherTable.register(UINib(nibName: "WeatherDayCell", bundle: nil), forCellReuseIdentifier: "dayCell")

        navigationTitle.title = city
        
        if let count = forecastData?.forecast?.count{
            tableSectionsCount = count
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
extension ForecastViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
    
    
    // Mark: - UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if let forecast1 = forecastData,let weatherData = forecast1.forecast?[row] {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as! WeatherDayCell
            cell.dayNameLabel.text = weatherData.date!.description
            cell.temperatureLabel.text = String(weatherData.temp) + "'C"
            cell.weatherImageBox.image = UIImage(imageLiteralResourceName: weatherData.type)
//                switch imageType {
//                case "Clear":
//                    cell.weatherImageBox.image =
//                    break
//                case "Snow":
//                    cell.weatherImageBox.image =  #imageLiteral(resourceName: "snow")
//                    break
//                case "Clouds":
//                    cell.weatherImageBox.image =  #imageLiteral(resourceName: "cloudy")
//                    break
//                case "Mist":
//                    cell.weatherImageBox.image =  #imageLiteral(resourceName: "mist")
//                    break
//                case "Rain":
//                    cell.weatherImageBox.image =  #imageLiteral(resourceName: "rain")
//                    break
//                default:
//                    cell.weatherImageBox.image =  #imageLiteral(resourceName: "cloudy")
//                    break
//                }
               return cell
            }
        return UITableViewCell(style: .default, reuseIdentifier: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSectionsCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
    
}
