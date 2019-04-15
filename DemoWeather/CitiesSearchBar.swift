//
//  CitiesSearchBar.swift
//  DemoWeather
//
//  Created by Mishko on 4/14/19.
//  Copyright © 2019 322org. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class CitiesSearchBar: UISearchBar, UISearchBarDelegate {
    
    var dictionary:[[String:Any]] = [[:]]
    var location:CLLocation?
    var searchActive = false
    
    var closure:(_:String)->Void = {_ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        if let path = Bundle.main.url(forResource: "city_list", withExtension: "json") {
            do {
                let data = try Data(contentsOf: path)
                dictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]]
            } catch {print(error.localizedDescription)}
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    //dictionary contains 200.000 + rows!
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        for item in dictionary {
            if item["name"] as! String == searchText {
                closure(searchText)
                return
            }
        }
    }

}
