//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Nataly on 29.06.2023.
//

import Foundation

struct WeatherResponse: Codable {
    let main: Main
    let weather: [WeatherCondition]
}

struct Main: Codable {
    let temp: Double
}

struct WeatherCondition: Codable {
    let description: String
    let icon: String
}
