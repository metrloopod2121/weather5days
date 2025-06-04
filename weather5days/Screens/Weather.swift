//
//  Weather.swift
//  weather5days
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 03.06.2025.
//

import Foundation
import SwiftUI

struct WeatherView: View {
    
    @State private var forecast: ForecastResponse?
    private let weatherManager = WeatherService()
    
    @AppStorage("temperatureUnit") private var temperatureUnit: String = "C"
    @AppStorage("windSpeedUnit") private var windSpeedUnit: String = "kph"
    @AppStorage("appTheme") private var appTheme: String = "system"
    @AppStorage("forecastHourInterval") private var forecastHourInterval: Int = 3
    @AppStorage("timeFormat") private var timeFormat: String = "24h"
    
    private var forecastCardWidth: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 100 : 60
    }
    
    private var forecastIconWidth: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 80 : 40
    }

    private var forecastFontSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 18 : 12
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .trailing) {
            headerView
            Spacer()
            if let forecast = forecast {
                forecastListView(forecast)
            }
        }
        .task { await fetchForecast() }
    }
}

// MARK: - Subviews

private extension WeatherView {
    
    var headerView: some View {
        VStack {
            HStack {
                Text(UserDefaults.standard.string(forKey: "forecastDays") ?? "3")
                    .font(.custom("Futura", size: 140))
                    .foregroundStyle(.white)
                    .shadow(radius: 15)
                VStack(alignment: .leading) {
                    Text("WEATHER")
                    Text("DAYS")
                }
                .font(.custom(RC.font, size: 60))
                .foregroundStyle(.white)
                .shadow(radius: 15)
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            Image("headBack")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
    }
    
    func forecastListView(_ forecast: ForecastResponse) -> some View {
        let city = UserDefaults.standard.string(forKey: "city") ?? "Moscow"
        
        return VStack(alignment: .trailing) {
            Text("in \(city)")
                .padding(.trailing, 30)
                .font(.custom("Futura", size: 20))
                .foregroundStyle(.white)
                .shadow(radius: 15)
            
            List(forecast.forecast.forecastday, id: \.date) { day in
                dayForecastRow(day: day, current: forecast.current)
            }
            .listStyle(.plain)
            .refreshable {
                await fetchForecast()
            }
        }
    }
    
    func dayForecastRow(day: ForecastDay, current: Current) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(formattedDate(from: day.date))
                    .font(.largeTitle)
                Spacer()
                Text(current.condition.text)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(stride(from: 0, to: day.hour.count, by: forecastHourInterval)), id: \.self) { i in
                        hourlyForecastCard(for: day.hour[i])
                    }
                }
                .padding(.horizontal, 8)
            }
        }
        .padding(.vertical, 8)
    }
    
    func hourlyForecastCard(for hour: Hour) -> some View {
        VStack(spacing: 8) {
            Text(formattedTime(from: hour.time))
                .foregroundStyle(.gray)
                .font(.system(size: forecastFontSize))
            
            AsyncImage(url: URL(string: "https:\(hour.condition.icon)")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: forecastIconWidth, height: forecastIconWidth)
            } placeholder: {
                ProgressView()
            }
            
            Text(formattedTemperature(hour.temp_c))
                .font(.system(size: forecastFontSize))
            
            Text(formattedWindSpeed(hour.wind_kph))
                .font(.system(size: forecastFontSize))
            
            Text("\(hour.humidity, specifier: "%.0f")%")
                .font(.system(size: forecastFontSize))
        }
        .frame(width: forecastCardWidth)
    }
}

// MARK: - Helpers

private extension WeatherView {
    
    func formattedDate(from string: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = inputFormatter.date(from: string) else { return string }
        
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        } else {
            return dateFormatter.string(from: date)
        }
    }
    
    func formattedTime(from string: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        guard let date = inputFormatter.date(from: string) else { return string }

        let formatter = DateFormatter()
        formatter.dateFormat = timeFormat == "24h" ? "HH:mm" : "h:mm a"
        return formatter.string(from: date)
    }
    
    func formattedTemperature(_ celsius: Double) -> String {
        let value = temperatureUnit == "C" ? celsius : (celsius * 9/5 + 32)
        return String(format: "%.1f °%@", locale: Locale(identifier: "en_US"), value, temperatureUnit)
    }
    
    func formattedWindSpeed(_ kph: Double) -> String {
        let value = windSpeedUnit == "kph" ? kph : kph / 1.609
        return String(format: "%.0f %@", value, windSpeedUnit)
    }
    
    func fetchForecast() async {
        do {
            forecast = try await weatherManager.getWeather()
        } catch {
            print("Ошибка: \(error)")
        }
    }
}
