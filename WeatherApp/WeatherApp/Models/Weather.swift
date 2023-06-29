//
//  Weather.swift
//  WeatherApp
//
//  Created by Nataly on 29.06.2023.
//

import Foundation

struct Weather {
    let temperature: Double
    let description: String
    let iconURL: URL?
    
    init(weatherResponse: WeatherResponse) {
        temperature = weatherResponse.main.temp
        description = weatherResponse.weather.first?.description ?? ""
        
        if let iconName = weatherResponse.weather.first?.icon {
            iconURL = URL(string: "https://openweathermap.org/img/w/\(iconName).png")
        } else {
            iconURL = nil
        }
    }
}
