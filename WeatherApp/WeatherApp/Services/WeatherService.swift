//  WeatherService.swift
//  WeatherApp
//
//  Created by Nataly on 29.06.2023.
//

import Foundation

class WeatherService: WeatherServiceProtocol {
    private let apiKey = "YOUR_KEY"
    
    func getCurrentWeather(city: String, completion: @escaping (Weather?, Error?) -> Void) {
        if let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCity)&appid=\(apiKey)"
            
            guard let url = URL(string: urlString) else {
                completion(nil, NSError(domain: "Invalid City", code: 0, userInfo: nil))
                return
            }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                        let weather = Weather(weatherResponse: weatherResponse)
                        completion(weather, nil)
                    } catch {
                        completion(nil, error)
                    }
                }
            }.resume()
        } else {
            completion(nil, NSError(domain: "Invalid City", code: 0, userInfo: nil))
        }
    }
}
