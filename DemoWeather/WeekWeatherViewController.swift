//
//  WeekWeatherViewController.swift
//  DemoWeather
//
//  Created by Mishko on 4/12/19.
//  Copyright © 2019 322org. All rights reserved.
//

import UIKit
import Foundation

class WeekWeatherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var forecastDictionary:[String:Any]?
    
    var tableSectionsCount = 0
    
    var list:[[String:Any]]?
    
    var temperatureArray:[Double] = []
    
    var date = Date()

    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    @IBOutlet weak var weatherTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherTable.dataSource = self
        weatherTable.delegate = self
        
        self.weatherTable.register(UINib(nibName: "WeatherDayCell", bundle: nil), forCellReuseIdentifier: "dayCell")

        
        list = forecastDictionary?["list"] as? [[String:Any]]
        if let _ = list?.count {
            tableSectionsCount = (list!.count - 1) / 6
        }
        
        if let list = self.list {
            for item in list {
                if let weather = item["main"] as? [String:Any] {
                    temperatureArray.append(weather["temp"] as? Double ?? 0.0)
                }
            }
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSectionsCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row * 6
        if let list = self.list {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as! WeatherDayCell
            if let weather = list[row]["weather"] as? [[String:Any]] {
                let imageType = weather[0]["main"] as! String
                switch imageType {
                case "Clear":
                    cell.weatherImageBox.image = #imageLiteral(resourceName: "bright_sunny")
                    break
                case "Snow":
                    cell.weatherImageBox.image = #imageLiteral(resourceName: "snow")
                    break
                case "Clouds":
                    cell.weatherImageBox.image = #imageLiteral(resourceName: "cloudy")
                    break
                case "Mist":
                    cell.weatherImageBox.image = #imageLiteral(resourceName: "mist")
                    break
                case "Rain":
                    cell.weatherImageBox.image = #imageLiteral(resourceName: "rain")
                    break
                default:
                    cell.weatherImageBox.image = #imageLiteral(resourceName: "cloudy")
                    break
                }
                let tempIndex = temperatureArray[row...row+6]
                cell.temperatureLabel.text = String(tempIndex.max()!) + "'C"
                // get day
                var index = row/6 + Calendar.current.firstWeekday
                if index > 6 {
                    index = index - 7
                }
                print(Calendar.current.weekdaySymbols)
                cell.dayNameLabel.text = Calendar.current.weekdaySymbols[index]
            }
            
            return cell
        }
        return UITableViewCell(style: .default, reuseIdentifier: nil)
    }
}
