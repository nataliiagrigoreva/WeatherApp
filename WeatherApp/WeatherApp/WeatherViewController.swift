//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nataly on 29.06.2023.
//

import UIKit

class WeatherViewController: UIViewController {
    private let weatherService: WeatherServiceProtocol
    private var weather: Weather?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "Weather App"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter city name"
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(cityTextField)
        view.addSubview(temperatureLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            cityTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 20),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 10),
            
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            iconImageView.heightAnchor.constraint(equalToConstant: 100),
            iconImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        cityTextField.addTarget(self, action: #selector(fetchWeather), for: .editingDidEndOnExit)
    }
    
    @objc private func fetchWeather() {
        guard let city = cityTextField.text else { return }
        
        weatherService.getCurrentWeather(city: city) { [weak self] (weather, error) in
            DispatchQueue.main.async {
                if let weather = weather {
                    self?.weather = weather
                    self?.updateUI(with: weather)
                } else if let error = error {
                    self?.showErrorAlert(with: error.localizedDescription)
                }
            }
        }
    }
    private func convertToCelsius(_ temperature: Double) -> Double {
        return temperature - 273.15
    }
    
    private func updateUI(with weather: Weather) {
        let celsiusTemperature = convertToCelsius(weather.temperature)
        temperatureLabel.text = String(format: "%.1f°C", celsiusTemperature)
        
        descriptionLabel.text = weather.description
        
        if let iconURL = weather.iconURL {
            URLSession.shared.dataTask(with: iconURL) { [weak self] (data, _, error) in
                if let error = error {
                    self?.showErrorAlert(with: error.localizedDescription)
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.iconImageView.image = image
                    }
                }
            }.resume()
        }
    }
    
    private func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = "Weather App"
    }
}
