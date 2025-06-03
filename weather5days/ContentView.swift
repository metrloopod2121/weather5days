//
//  ContentView.swift
//  weather5days
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 03.06.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            WeatherView()
                .tabItem {
                    Label("Weather", systemImage: "cloud.sun.rain")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
}
