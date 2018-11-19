//
//  Utility.swift
//  WeatherForecast
//
//  Created by Juhi Gautam on 16/11/18.
//  Copyright © 2018 Juhi Gautam. All rights reserved.
//

import UIKit

class Utility: NSObject {
    static let sharedUtility = Utility()
    override init(){}
    func convertUtcToLocalTime (date :String) -> String{
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-mm-dd H:mm:ss"
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        //dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale!
//
//        let dt = dateFormatter.date(from: date)
//        //dateFormatter.timeZone = NSTimeZone.local
//        dateFormatter.dateFormat = "dd-MM-yyyy"
//        let localeDate = dateFormatter.string(from: dt!)
//        return localeDate
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        let localeDate = dateFormatterGet.date(from: date)
        return dateFormatterPrint.string(from: localeDate!)
    }
    
    func saveData(jsonData : NSDictionary){
        let cityDict = jsonData["city"] as! NSDictionary
        let cityName = cityDict["name"] as! String
        let responseData = jsonData["list"] as! [NSDictionary]
        var weatherInfoList = [WeatherInfo]()
        for responsedict in responseData{
            let dateStr = self.convertUtcToLocalTime(date: responsedict["dt_txt"] as! String)
            let main = responsedict["main"] as! NSDictionary
            let temperature_maxInKelvin = main["temp_max"] as! NSNumber
            let temperature_maxInCelsius = temperature_maxInKelvin.doubleValue - 273.15
            let temp_max = String(format: "%.0f°", temperature_maxInCelsius)
            let temperature_minInKelvin = main["temp_min"] as! NSNumber
            let temperature_minInCelsius = temperature_minInKelvin.doubleValue - 273.15
            let temp_min = String(format: "%.0f°", temperature_minInCelsius)
            let weather = responsedict["weather"] as! NSArray
            let weatherDict = weather[0] as! NSDictionary
            let status = weatherDict["description"] as! String
            let weatherData : WeatherInfo = WeatherInfo.init(dateOfForecast: dateStr, status: status, temperatureMin: temp_min, temperatureMax: temp_max)
            if weatherInfoList.contains( where: { $0.dateOfForecast == weatherData.dateOfForecast } ) == false {
                weatherInfoList.append(weatherData)
                print("Object Added")
            } else {
                print("Object already exists")
            }
        }
        
        let userDefault = UserDefaults.standard
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: weatherInfoList)
        userDefault.set(encodedData, forKey: "weatherInfoList")
        userDefault.set(cityName, forKey: "cityName")
        NotificationCenter.default.post(name: Notification.Name("DataSaved"), object: nil)
    }
    
}
