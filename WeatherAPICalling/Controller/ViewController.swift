//
//  ViewController.swift
//  WeatherAPICalling
//
//  Created by Arpit iOS Dev. on 06/06/24.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlet
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var countryNameDropDown: UIButton!
    @IBOutlet var countryName: [UIButton]!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var stackViewLbl: UIStackView!
    // Current Data Outlet
    @IBOutlet weak var observationTimeLbl: UILabel!
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var weatherCodeLbl: UILabel!
    @IBOutlet weak var weatherIconImage: UIImageView!
    @IBOutlet weak var weatherDescriptionLbl: UILabel!
    @IBOutlet weak var windSpeedLbl: UILabel!
    @IBOutlet weak var windDegreeLbl: UILabel!
    @IBOutlet weak var windDirLbl: UILabel!
    @IBOutlet weak var pressureLbl: UILabel!
    @IBOutlet weak var precipLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var cloudcoverLbl: UILabel!
    @IBOutlet weak var feelslikeLbl: UILabel!
    @IBOutlet weak var uvIndexLbl: UILabel!
    @IBOutlet weak var visibilityLbl: UILabel!
    
    var selectedCountry: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryName.forEach { btn in
            btn.isHidden = true
            btn.alpha = 0
        }
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.shadowOpacity = 0.5
        stackView.layer.shadowOffset = CGSize(width: 3, height: 3)
        stackView.layer.shadowRadius = 10
        stackView.layer.masksToBounds = false
        
        countryTextField.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func fetchWeatherData(forCity city: String) {
        let queryParameters: [String: String] = [
            "access_key": "e29829ed1e345bc8d1c5b485cc8b4d69",
            "query": city
        ]
        
        APIManager.shared.postWeatherData( queryParams: queryParameters) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    do {
                        let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                        
                        print("Observation Time: \(weatherResponse.current.observationTime)")
                        print("Temperature: \(weatherResponse.current.temperature)°C")
                        print("Weather Code: \(weatherResponse.current.weatherCode)")
                        print("Weather Icons: \(weatherResponse.current.weatherIcons.joined(separator: ", "))")
                        print("Weather Descriptions: \(weatherResponse.current.weatherDescriptions.joined(separator: ", "))")
                        print("Wind Speed: \(weatherResponse.current.windSpeed) km/h")
                        print("Wind Degree: \(weatherResponse.current.windDegree)°")
                        print("Wind Direction: \(weatherResponse.current.windDir)")
                        print("Pressure: \(weatherResponse.current.pressure) hPa")
                        print("Precipitation: \(weatherResponse.current.precip) mm")
                        print("Humidity: \(weatherResponse.current.humidity)%")
                        print("Cloud Cover: \(weatherResponse.current.cloudcover)%")
                        print("Feels Like: \(weatherResponse.current.feelslike)°C")
                        print("UV Index: \(weatherResponse.current.uvIndex)")
                        print("Visibility: \(weatherResponse.current.visibility) km")
                        print("Is Day: \(weatherResponse.current.isDay)")
                        
                        self.observationTimeLbl.text = "Observation Time: \(weatherResponse.current.observationTime)"
                        self.temperatureLbl.text = "Temperature: \(weatherResponse.current.temperature)°C"
                        self.weatherCodeLbl.text = "Weather Code: \(weatherResponse.current.weatherCode)"
                        self.weatherDescriptionLbl.text = "Weather Descriptions: \(weatherResponse.current.weatherDescriptions.joined(separator: ", "))"
                        self.windSpeedLbl.text = "Wind Speed: \(weatherResponse.current.windSpeed) km/h"
                        self.windDegreeLbl.text = "Wind Degree: \(weatherResponse.current.windDegree)°"
                        self.windDirLbl.text = "Wind Direction: \(weatherResponse.current.windDir)"
                        self.pressureLbl.text = "Pressure: \(weatherResponse.current.pressure) hPa"
                        self.precipLbl.text = "Precipitation: \(weatherResponse.current.precip) mm"
                        self.humidityLbl.text = "Humidity: \(weatherResponse.current.humidity)%"
                        self.cloudcoverLbl.text = "Cloud Cover: \(weatherResponse.current.cloudcover)%"
                        self.feelslikeLbl.text = "Feels Like: \(weatherResponse.current.feelslike)°C"
                        self.uvIndexLbl.text = "UV Index: \(weatherResponse.current.uvIndex)"
                        self.visibilityLbl.text = "Visibility: \(weatherResponse.current.visibility) km"
                        
                        if weatherResponse.current.isDay == "yes" {
                            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "dayBackground")!)
                        } else {
                            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "nightBackground")!)
                        }
                        
                        if let iconURLString = weatherResponse.current.weatherIcons.first, let iconURL = URL(string: iconURLString) {
                            self.downloadWeatherIcon(from: iconURL)
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func downloadWeatherIcon(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to download weather icon:", error?.localizedDescription ?? "")
                return
            }
            DispatchQueue.main.async {
                self.weatherIconImage.image = UIImage(data: data)
            }
        }.resume()
    }
    
    @IBAction func countryNameDropDown(_ sender: UIButton) {
        countryName.forEach { btn in
            UIView.animate(withDuration: 0.5) {
                btn.isHidden = !btn.isHidden
                btn.alpha = btn.alpha == 0 ? 1 : 0
            }
        }
    }
    @IBAction func countryNameTapped(_ sender: UIButton) {
        if let btn1 = (sender as AnyObject).titleLabel?.text {
            self.countryTextField.text = btn1
            animate(toggel: false)
        }
    }
    
    // MARK: - Animation Function
    func animate(toggel: Bool) {
        if toggel {
            countryName.forEach { btn in
                UIView.animate(withDuration: 0.5) {
                    btn.isHidden = false
                    btn.alpha = btn.alpha == 0 ? 1 : 0
                }
            }
        } else {
            countryName.forEach { btn in
                UIView.animate(withDuration: 0.5) {
                    btn.isHidden = true
                    btn.alpha = btn.alpha == 0 ? 1 : 0
                }
            }
        }
    }
    
    @IBAction func btnWeatherGetTapped(_ sender: UIButton) {
        
        guard let city = countryTextField.text, !city.isEmpty else {
            showAlert(message: "Please enter a city.")
            return
        }
        
        fetchWeatherData(forCity: city)
        
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
}
