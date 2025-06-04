//
//  Settings.swift
//  weather5days
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 03.06.2025.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @AppStorage("city") private var city: String = ""
    @AppStorage("forecastDays") private var forecastDays: Int = 5
    @AppStorage("temperatureUnit") private var temperatureUnit: String = "C"
    @AppStorage("windSpeedUnit") private var windSpeedUnit: String = "kph"
    @AppStorage("appTheme") private var appTheme: String = "system"
    @AppStorage("forecastHourInterval") private var forecastHourInterval: Int = 3
    @AppStorage("timeFormat") private var timeFormat: String = "24h"
    @AppStorage("useCurrentLocation") private var useCurrentLocation: Bool = false

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Город")) {
                    TextField("Введите город", text: $city)
                        .textInputAutocapitalization(.words)
                }

                Section(header: Text("Количество дней")) {
                    Stepper(value: $forecastDays, in: 1...10) {
                        Text("\(forecastDays) дней")
                    }
                }

                Section(header: Text("Единицы измерения")) {
                    Picker("Температура", selection: $temperatureUnit) {
                        Text("°C").tag("C")
                        Text("°F").tag("F")
                    }
                    
                    Picker("Скорость ветра", selection: $windSpeedUnit) {
                        Text("kph").tag("kph")
                        Text("mph").tag("mph")
                    }
                }

                Section(header: Text("Время")) {
                    Picker("Формат времени", selection: $timeFormat) {
                        Text("24ч").tag("24h")
                        Text("12ч").tag("12h")
                    }
                    
                    
                    Picker("Интервал", selection: $forecastHourInterval) {
                        Text("1 час").tag(1)
                        Text("3 часа").tag(3)
                        Text("6 часов").tag(6)
                    }
                    .padding()
                    .pickerStyle(.segmented)
                }
                
                HStack {
                    Spacer()
                    Label("Developer — Podgorny Matthew", systemImage: "hammer.fill")
                        .font(.footnote)
                    
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .listRowBackground(Color.clear)


    //            }
    //            .navigationTitle("Настройки")
        }
        }
    }
}

#Preview {
    ContentView()
}
