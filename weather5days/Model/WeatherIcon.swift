//
//  WeatherIcon.swift
//  weather5days
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 03.06.2025.
//

import Foundation

enum WeatherIconCaption: String {
    case sunny, clear = "113"
    case partlyCloudy = "116"
    case cloudy = "119"
    case overcast = "122"
    case mist = "143"
    case patchyRainNearby = "176"
    case patchySnowNearby = "179"
    case patchySleetNearby = "182"
    case patchyFreezingDrizzleNearby = "185"
    case thunderyOutbreaksNearby = "200"
    case blowingSnow = "227"
    case blizzard = "230"
    case fog = "248"
    case freezingFog = "260"
    case patchyLightDrizzle = "263"
    case lightDrizzle = "266"
    case freezingDrizzle = "281"
    case heavyFreezingDrizzle = "284"
    case patchyLightRain = "293"
    case lightRain = "296"
    case moderateRainAtTimes = "299"
    case moderateRain = "302"
    case heavyRainAtTimes = "305"
    case heavyRain = "308"
    case lightFreezingRain = "311"
    case moderateOrHeavyFreezingRain = "314"
    case lightSleet = "317"
    case moderateOrHeavySleet = "320"
    case patchyLightSnow = "323"
    case lightSnow = "326"
    case patchyModerateSnow = "329"
    case moderateSnow = "332"
    case patchyHeavySnow = "335"
    case heavySnow = "338"
    case icePellets = "350"
    case lightRainShower = "353"
    case moderateOrHeavyRainShower = "356"
    case torrentialRainShower = "359"
    case lightSleetShowers = "362"
    case moderateOrHeavySleetShowers = "365"
    case lightSnowShowers = "368"
    case moderateOrHeavySnowShowers = "371"
    case lightShowersOfIcePellets = "374"
    case moderateOrHeavyShowersOfIcePellets = "377"
    case patchyLightRainWithThunder = "386"
    case moderateOrHeavyRainWithThunder = "389"
    case patchyLightSnowWithThunder = "392"
    case moderateOrHeavySnowWithThunder = "395"

    static func from(id: String) -> WeatherIconCaption? {
        return WeatherIconCaption(rawValue: id)
    }
    
    static func url(for iconId: String, isDay: Bool) -> String {
        let baseURL = isDay
            ? "https://cdn.weatherapi.com/weather/64x64/day/"
            : "https://cdn.weatherapi.com/weather/64x64/night/"
        return baseURL + iconId + ".png"
    }
}

struct WeatherIconURL {
    static func url(for iconId: String, isDay: Bool) -> String {
        let baseURL = isDay
            ? "https://cdn.weatherapi.com/weather/64x64/day/"
            : "https://cdn.weatherapi.com/weather/64x64/night/"
        return baseURL + iconId + ".png"
    }
}
