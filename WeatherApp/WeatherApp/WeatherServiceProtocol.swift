//
//  WeatherServiceProtocol.swift
//  WeatherApp
//
//  Created by Nataly on 29.06.2023.
//

import Foundation

protocol WeatherServiceProtocol {
    func getCurrentWeather(city: String, completion: @escaping (Weather?, Error?) -> Void)
}
