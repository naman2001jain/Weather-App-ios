//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation


class WeatherViewController: UIViewController {
    @IBAction func currentLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    var animationStruct = AnimationStruct()
    
    var weatherManager = WeatherManager()
    @IBOutlet weak var locationButtonOutlet: UIButton!
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
        
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                self.animationStruct.applyRotationEffect(on: self.locationButtonOutlet, by: 360)
            }
        
        
       
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        

    }
}



//MARK:- extension UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{
    
    
    
    @IBAction func searchButton(_ sender: UIButton) {
        searchTextField.endEditing(true) //if editing is done then dismiss the keyboard
        
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if searchTextField.text != ""{
            return true
        }
        else{ //if user didn't typed anything
            searchTextField.placeholder = "Type Something..."
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""  //after typing the text will be diminished
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchTextField.endEditing(true) //if editing is done then dismiss the keyboard
        
        return true
    }
    
    
    
}

//MARK:- WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    func didUpdateWeather(weather: WeatherModel){
        
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
           
        }
    }
    func didFailWithError(with error: Error) {
        print(error)
    }
}


extension WeatherViewController :CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location found")
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
