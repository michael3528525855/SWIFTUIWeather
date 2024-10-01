import SwiftUI
import CoreLocation

struct WeatherView: View {
    @State var city: String = ""
    @StateObject var weatherManager = WeatherManager()
    @StateObject var locationManager = LocationManager() // New instance of LocationManager
    @State var userLatitude: Double?
    @State var userLongitude: Double?
    
    var body: some View {
        VStack(
            alignment: .trailing,
            spacing: 10
        ) {
            HStack {
                Button(action: {
                    fitchLocation() // Fetch location and weather based on it
                }) {
                    Image(systemName: "location.viewfinder")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                }
                
                TextField("Enter city name", text: $city, onCommit: {
                    weatherManager.fetchWeather(cityName: city)  // Fetch weather when user presses Enter
                })
                .padding()
                .textInputAutocapitalization(.words)
                .background(Color.gray.opacity(0.3).cornerRadius(15))
                
                Button(action: {
                    weatherManager.fetchWeather(cityName: city)  // Fetch weather when user taps the button
                }) {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                }
            }
            
            VStack(spacing: 10) {
                Text(weatherManager.cityName)
                    .font(.largeTitle)
                    .padding()
                
                Text("\(weatherManager.temperature, specifier: "%.1f")°C")  // Display temperature
                    .font(.system(size: 64))
                
                Image(systemName: weatherManager.conditionName)
                    .font(.system(size: 64))
                    .foregroundColor(.blue)
            }
            .padding()
            
            Spacer()
        }
        .onAppear {
            if let location = locationManager.location {
                userLatitude = location.latitude
                userLongitude = location.longitude
                weatherManager.fetchWeather(latitude: userLatitude!, longitude: userLongitude!) // Fetch weather for current location
            }
        }
        .padding()
        .background(Image("background"))
    }
    
    // Fetch weather based on user's location
    func fitchLocation() {
        locationManager.requestLocation()  // Request current location from the LocationManager
        if let location = locationManager.location {
            weatherManager.fetchWeather(latitude: location.latitude, longitude: location.longitude)
        }
    }
}

#Preview {
    WeatherView()
}
