//
//  WeatherHandler.swift
//  WeatherForecast
//
//  Created by Juhi Gautam on 16/11/18.
//  Copyright © 2018 Juhi Gautam. All rights reserved.
//

import UIKit


class WeatherHandler: NSObject {
    
    static let sharedWeatherHandler = WeatherHandler()
    override init(){}
    func fetchWeatherForcast(url : URL , withCompletion completion: @escaping (Bool) -> Void) {
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                completion(false)
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                completion(false)
                return
            }
            print(json)
            Utility.sharedUtility.saveData(jsonData: json as! NSDictionary)
            completion(true)
        })
        task.resume()
    }

}
