//
//  DetailVC.swift
//  WeatherGift
//
//  Created by CSOM on 3/19/17.
//  Copyright © 2017 CSOM. All rights reserved.
//

import UIKit
import CoreLocation

class DetailVC: UIViewController {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        locationManager.delegate = self
        if currentPage == 0{
            getLocation()
        }
        
        locationsArray[currentPage].getWeather {
            self.updateUserInterface()
        }
        updateUserInterface()
        
    }
    
    func updateUserInterface() {
        
        let isHidden = (locationsArray[currentPage].currentTemp == -999.9)
        temperatureLabel.isHidden = isHidden
        locationLabel.isHidden = isHidden
        
        locationLabel.text = locationsArray[currentPage].name
        dateLabel.text = formatTimeForTimeZone(unixDateToFormat: locationsArray[currentPage].currentTime, timeZoneString: locationsArray[currentPage].timeZone)
        // dateLabel.text = locationsArray[currentPage].coordinates
        let curTemperature = String(format: "%3.f", locationsArray[currentPage].currentTemp) + "°"
        temperatureLabel.text = curTemperature
        print("%%% curTemperature inside updateUserInterface = \(curTemperature)")
        summaryLabel.text = locationsArray[currentPage].dailySummary
        currentImage.image = UIImage(named: locationsArray[currentPage].currentIcon)
        tableView.reloadData()
    }
    
    func formatTimeForTimeZone(unixDateToFormat: TimeInterval, timeZoneString: String) ->
        String {
            let usableDate = Date(timeIntervalSince1970: unixDateToFormat)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMM dd, y"
            dateFormatter.timeZone = TimeZone(identifier: timeZoneString)
            let dateString = dateFormatter.string(from: usableDate)
            return dateString
    }
    
    
}

extension DetailVC: CLLocationManagerDelegate {
    
    func getLocation() {
        let status = CLLocationManager.authorizationStatus()
        
        handleLocationAuthorizationStatus(status: status)
        
    }
    
    func handleLocationAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied:
            print("Cannot display location. Your dumb ass didn't enable it.")
        case .restricted:
            print("Access Denied - Mommy and Daddy probably don't trust you.")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorizationStatus(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if currentPage == 0 {
            
            let geoCoder = CLGeocoder()
            
            currentLocation = locations.last
            
            
            let currentLat = "\(currentLocation.coordinate.latitude)"
            let currentLong = "\(currentLocation.coordinate.longitude)"
            
            print("coordinates are:" + currentLat + currentLong)
            
            var place = ""
            geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: {placemarks, error in
                if placemarks != nil{
                    let placemark = placemarks!.last
                    place = (placemark?.name!)!
                }else {
                    print("Error retrieving place. Error code: \(error)")
                    place = "Parts Unknown"}
                print (place)
                self.locationsArray[0].name = place
                self.locationsArray[0].coordinates = currentLat + "," + currentLong
                self.locationsArray[0].getWeather{
                    self.updateUserInterface()
                }
                
                
            })
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error getting location - error code \(error)")
    }
    

}

extension DetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsArray[currentPage].dailyForecastArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayWeatherCell") as!
            DayWeatherCell
        cell.configureTableCell(dailyForecast: self.locationsArray[currentPage].dailyForecastArray[indexPath.row], timeZone: self.locationsArray[currentPage].timeZone)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
