import Foundation
import CoreLocation
protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(with error:Error)
}

struct WeatherManager{
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=a38b5082912036092b22344d4f2ea55b&units=metric"
    var temp:String?
    var delegate: WeatherManagerDelegate?
    
    
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(with: urlString)
    }
    func fetchWeather(latitude: CLLocationDegrees, longitude:CLLocationDegrees){
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
        print(urlString)
    }
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){//step1 create a url
            
            let session = URLSession(configuration: .default)//step2 create session
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    delegate?.didFailWithError(with: error!)
                    return
                }
                if let safeData = data{
                    if let weather = self.parseJSON(weatherData: safeData){
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }//give the session a task
            
            task.resume() // start the task
        }
    }
    func parseJSON(weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let temperature = decodedData.main.temp
            let city = decodedData.name
            let id = decodedData.weather[0].id
            let description = decodedData.weather[0].description
            let weatherModel = WeatherModel(temp: temperature, conditionId: id, cityName: city,description: description)
            return weatherModel
        }
        catch{
            delegate?.didFailWithError(with: error)
            return nil
        }
        
    }
    
    
}


