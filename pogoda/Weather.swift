//
//  Weather.swift
//  pogoda
//
//  Created by Piotr Snopek on 17/10/2019.
//  Copyright © 2019 Piotr Snopek. All rights reserved.
//


import Foundation
import CoreLocation

struct Weather {
    let weatherType:String
    let maxTemp:Double
    let minTemp:Double
    let windSpeed:Double
    let windDirection:Double
    let rain:Double
    let pressure:Double
    let icon:String
    let timeStamp:Double
    
    init(json:[String:Any]) {
        self.windDirection = json["windBearing"] as! Double
        
        self.rain = json["precipIntensity"] as! Double
        
        self.pressure = json["pressure"] as! Double
        
        self.icon = json["icon"] as! String
        
        self.timeStamp = json["time"] as! Double
        
        self.weatherType = json["summary"] as! String
        
        self.maxTemp = json["temperatureMax"] as! Double
        
        self.minTemp = json["temperatureMin"] as! Double
        
        self.windSpeed = json["windSpeed"] as! Double
    }

    
    static func fetch (latitude: String, longitude: String, completion: @escaping ([Weather]?) -> ()) {
        
        let API = "https://api.darksky.net/forecast/573bffb42f1bdd32f31f40b1571b01c2/"
        
        let url = API + "\(latitude),\(longitude)?exclude=minutely,hourly,currently&units=si"
        
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var forecastArray:[Weather] = []
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["daily"] as? [String:Any] {
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
                                for dataPoint in dailyData {
                                    let weatherObject = Weather(json: dataPoint)
                                    forecastArray.append(weatherObject)
                                }
                            }
                        }
                    
                    }
                }catch {
                    print(error.localizedDescription)
                }
                completion(forecastArray)
            }
        }
        task.resume()
    }
    

}
