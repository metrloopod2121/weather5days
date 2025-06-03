//
//  ForecastResponse.swift
//  weather5days
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 03.06.2025.
//

import Foundation


struct ForecastResponse: Decodable {
    let forecast: Forecast
    let current: Current
}

struct Current: Decodable {
    let condition: Condition
}

struct Forecast: Decodable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Decodable {
    let date: String
    let day: DayInfo
    let astro: Astro
    let hour: [Hour]
}

struct Hour: Decodable {
    let time: String
    let condition: Condition
    let temp_c: Double
    let temp_f: Double
    let wind_kph: Double
    let wind_mph: Double
    let humidity: Double
}

struct Astro: Decodable {
    let sunrise: String
    let sunset: String
}

struct DayInfo: Decodable {
    let avgtemp_c: Double
    let maxwind_kph: Double
    let avghumidity: Double
}

struct Condition: Decodable {
    let text: String
    let icon: String
}
