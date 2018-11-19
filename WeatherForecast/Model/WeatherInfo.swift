//
//  WeatherInfo.swift
//  WeatherForecast
//
//  Created by Juhi Gautam on 16/11/18.
//  Copyright © 2018 Juhi Gautam. All rights reserved.
//

import UIKit

class WeatherInfo: NSObject,NSCoding {
    // the date this weather is relevant to
    var dateOfForecast: String?
    // the general weather status: clouds, rain, thunderstorm, snow, etc...
    var status: String?
    // min/max temp in farenheit
    var temperatureMin: String?
    var temperatureMax: String?
    
    init(dateOfForecast: String?,status: String?,temperatureMin: String?,temperatureMax: String?){
        self.dateOfForecast = dateOfForecast
        self.status = status
        self.temperatureMin = temperatureMin
        self.temperatureMax = temperatureMax

    }
    
    // MARK: - NSCoding
    required init(coder aDecoder: NSCoder) {
        dateOfForecast = aDecoder.decodeObject(forKey: "dateOfForecast") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        temperatureMin = aDecoder.decodeObject(forKey: "temperatureMin") as? String
        temperatureMax = aDecoder.decodeObject(forKey: "temperatureMax") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(dateOfForecast, forKey: "dateOfForecast")
        aCoder.encode(status, forKey: "status")
        aCoder.encode(temperatureMin, forKey: "temperatureMin")
        aCoder.encode(temperatureMax, forKey: "temperatureMax")
    }
    
}
