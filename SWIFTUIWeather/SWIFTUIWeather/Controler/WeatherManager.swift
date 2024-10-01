import Foundation

class WeatherManager: ObservableObject {
    @Published var cityName = ""
    @Published var temperature: Double = 0.0
    @Published var conditionName = ""
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=fea3e0a9a9774fd60b1f37833013bbcd&units=metric"
    
    // Fetch weather by city name
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    // Fetch weather by latitude and longitude
    func fetchWeather(latitude: Double, longitude: Double) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    // Perform network request
    private func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                if let safeData = data, let weather = self.parseJSON(safeData) {
                    DispatchQueue.main.async {
                        self.cityName = weather.cityName
                        self.temperature = weather.temperature
                        self.conditionName = weather.conditionName
                    }
                }
            }
            task.resume()
        }
    }
    
    // Parse the JSON response
    private func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            return WeatherModel(conditionId: id, cityName: name, temperature: temp)
        } catch {
            print("Error parsing JSON: \(error)")
            return nil
        }
    }
}
