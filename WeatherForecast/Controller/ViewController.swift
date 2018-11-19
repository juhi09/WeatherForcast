//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Juhi Gautam on 15/11/18.
//  Copyright © 2018 Juhi Gautam. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var cityLabel: UILabel!
    // cell reuse id (cells that scroll out of view can be reused)
    var locationManager = CLLocationManager()
    
    // Default Latitude and Longitude of Bangalore
    var lat = 12.97194
    var lng = 77.59369
    
    var weatherDataList : [WeatherInfo]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI(notification:)), name: Notification.Name("DataSaved"), object: nil)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Register the table view cell class and its reuse id
        self.tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "weatherCell")
        // (optional) include this line if you want to remove the extra empty cell divider lines
        self.tableView.tableFooterView = UIView()
        
        // Request Device Location
         requestLocationPermision()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func requestLocationPermision() {
        
        //self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        self.fetchWeatherForcast()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            lat = location.coordinate.latitude
            lng = location.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("locationDisabled")
            case .authorizedAlways, .authorizedWhenInUse:
                print("locationEnabled")
            }
        } else {
            print("locationDisabled")
        }
        manager.stopUpdatingLocation()
    }
    
    class func isLocationEnabled() -> (status: Bool, message: String) {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return (false,"No access")
            case .authorizedAlways, .authorizedWhenInUse:
                return(true,"Access")
            }
        } else {
            return(false,"Turn On Location Services to Allow App to Determine Your Location")
        }
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.weatherDataList != nil {
            return self.weatherDataList!.count
        }
        return 0
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath ) as! WeatherTableViewCell
        
        // set the text from the data model
        if self.weatherDataList!.count > 0{
            let weatherInfo = self.weatherDataList![indexPath.row]
            cell.myStatusLabel?.text = weatherInfo.status
            cell.myDateLabel?.text = weatherInfo.dateOfForecast
            cell.myMaxLabel?.text = weatherInfo.temperatureMax
            cell.myMinLabel?.text = weatherInfo.temperatureMin
        }
        return cell
    }
    // height of row in table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    // fetch for 5 days Weather Forcast Using Open Weather Map
    func fetchWeatherForcast(){
        let urlStr = "\(Constants.kBaseURL)\(Constants.kForecastURL)lat=\(lat)&lon=\(lng)&appid=\(Constants.kAppId)"
        let url = URL(string: urlStr)!
        WeatherHandler.sharedWeatherHandler.fetchWeatherForcast(url: url){ finish in
            if (UserDefaults.standard.value(forKey: "weatherInfoList") != nil){
                let userDefault = UserDefaults.standard
                let decoded  = userDefault.object(forKey: "weatherInfoList") as! Data
                self.weatherDataList = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [WeatherInfo]
                let cityName = userDefault.object(forKey: "cityName") as! String
                self.cityLabel.text = cityName
                self.tableView.reloadData()
            }
        }
    }
    
    // Update Weather Array and reload Table View 
    @objc func updateUI(notification: Notification) {
        if (UserDefaults.standard.value(forKey: "weatherInfoList") != nil){
            let userDefault = UserDefaults.standard
            let decoded  = userDefault.object(forKey: "weatherInfoList") as! Data
            self.weatherDataList = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [WeatherInfo]
            let cityName = userDefault.object(forKey: "cityName") as! String
            self.cityLabel.text = cityName
            self.tableView.reloadData()
        }
    }
}

