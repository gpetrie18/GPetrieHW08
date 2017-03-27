//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by CSOM on 3/26/17.
//  Copyright © 2017 CSOM. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherLocation {
    var name = ""
    var coordinates = ""
    var currentTemp = -999.9
    var dailySummary = ""
    
    func getWeather(completed: @escaping () -> ()) {
        
        let weatherURL = urlBase + urlAPIKey + coordinates
        
        Alamofire.request(weatherURL).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let summary = json["daily"]["summary"].string {
                    print("SUMMARY inside getWeather = \(summary)")
                    self.dailySummary = summary
                }else {
                    print("could not return a temperature!")
                }
            case .failure(let error):
                print(error)
            }
            completed()
        }
    }
}
    
