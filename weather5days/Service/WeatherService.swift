//
//  WeatherService.swift
//  weather5days
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 03.06.2025.
//

import Foundation

struct WeatherService {
    
    private func makeURL() -> URL? {
        let city = UserDefaults.standard.string(forKey: "city") ?? "Moscow"
        let forecastDays = UserDefaults.standard.integer(forKey: "forecastDays")
        let days = forecastDays > 0 ? forecastDays : 5  // дефолтное значение

        
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else {
            print("API Key not found")
            return nil
        }
        
        
        let baseURL = "https://api.weatherapi.com/v1/forecast.json?"
        let cityQuery = "q=\(city)"
        let daysQuery = "days=\(days)"
        let apiKeyQuery = "key=\(apiKey)"
        
        let urlString = "\(baseURL)\(cityQuery)&\(daysQuery)&\(apiKeyQuery)"
        print(urlString)
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return nil
        }
        
        return url
    }
    
    func getWeather() async throws -> ForecastResponse {
        

        guard let url = makeURL() else {
            print("Invalid URL")
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let forecast = try JSONDecoder().decode(ForecastResponse.self, from: data)
        print(forecast.forecast.forecastday.count)
        return forecast
    }

}
