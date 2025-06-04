//
//  Weather.swift
//  weather5days
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 03.06.2025.
//

import Foundation
import SwiftUI

struct WeatherView: View {
    
    private var weatherManager = WeatherService()
    @State private var forecast: ForecastResponse?
    
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
    
    
    private func formattedDate(from string: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = inputFormatter.date(from: string) else {
            return string
        }
        
        let calendar = Calendar.current
        if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        }
        
        if calendar.isDateInToday(date) {
            return "Today"
        }
        
        return dateFormatter.string(from: date)
    }
    
    private func formattedTime(from string: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        guard let date = inputFormatter.date(from: string) else {
            return string
        }

        let formatter = DateFormatter()
        formatter.dateFormat = timeFormat == "24h" ? "HH:mm" : "h:mm a"
        return formatter.string(from: date)
    }
    
    func dayForecastRow(day: ForecastDay, current: Current) -> some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(formattedDate(from: day.date))
                        .font(.largeTitle)
                    Spacer()
                    Text(current.condition.text)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                HStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(Array(stride(from: 0, to: day.hour.count, by: forecastHourInterval)), id: \.self) { i in
                                VStack(spacing: 8) {
                                    Text(formattedTime(from: day.hour[i].time))
                                        .foregroundStyle(.gray)
                                        .font(.system(size: forecastFontSize))
                                    AsyncImage(url: URL(string: "https:\(day.hour[i].condition.icon)")) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: forecastIconWidth, height: forecastIconWidth)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    Text(String(format: "%.1f", locale: Locale(identifier: "en_US"), temperatureUnit == "C" ? day.hour[i].temp_c : (day.hour[i].temp_c * 9/5 + 32)) + " °\(temperatureUnit)")
                                        .font(.system(size: forecastFontSize))
                                    Text(String(format: "%.0f", windSpeedUnit == "kph" ? day.hour[i].wind_kph : day.hour[i].wind_kph / 1.609) + " \(windSpeedUnit)")
                                        .font(.system(size: forecastFontSize))
                                    Text("\(day.hour[i].humidity, specifier: "%.0f")%")
                                        .font(.system(size: forecastFontSize))
                                }
                                .frame(width: forecastCardWidth)
                            }
                        }
                        .padding(.horizontal, 8)
                    }
                    
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    var body: some View {

        VStack(alignment: .trailing) {
            VStack {
                HStack {
                    Text(UserDefaults.standard.string(forKey: "forecastDays") ?? "3")
                        .font(Font.custom("Futura", size: 140))
                        .foregroundStyle(.white)
                        .shadow(radius: 15)
                    VStack(alignment: .leading) {
                        Text("WEATHER")
                            .font(Font.custom(RC.font, size: 60))
                            .foregroundStyle(.white)
                            .shadow(radius: 15)
                        Text("DAYS")
                            .font(Font.custom(RC.font, size: 60))
                            .foregroundStyle(.white)
                            .shadow(radius: 15)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(
                Image("headBack")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
            
            Spacer()
            
            if let forecast = forecast {
                let city = UserDefaults.standard.string(forKey: "city") ?? "Moscow"
                Text("in \(city)")
                    .padding(.trailing, 30)
                    .font(Font.custom("Futura", size: 20))
                    .foregroundStyle(.white)
                    .shadow(radius: 15)
                
                

                List(forecast.forecast.forecastday, id: \.date) { day in
                    dayForecastRow(day: day, current: forecast.current)
                }
                .listStyle(.plain)
                .refreshable {
                    do {
                        self.forecast = try await weatherManager.getWeather()
                    } catch {
                        print("Ошибка: \(error)")
                    }
                }
                
            }
        }
        .task {
            do {
                forecast = try await weatherManager.getWeather()
            } catch {
                print("Ошибка: \(error)")
            }
        }
        

    }
    
}


#Preview {
    ContentView()
}
