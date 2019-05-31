//
//  Weather.swift
//  RxSwiftWeather
//
//  Created by Federico Nieto on 30/05/2019.
//  Copyright © 2019 Federico Nieto. All rights reserved.
//

import UIKit

struct WeatherResult: Decodable {
    let main: Weather
}

extension WeatherResult {
    
    static var empty: WeatherResult {
        return WeatherResult(main: Weather(temp: 0.0, humidity: 0.0))
    }
    
}

struct Weather: Decodable {
    let temp: Double
    let humidity: Double
}
