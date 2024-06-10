//
//  Model.swift
//  WeatherAPICalling
//
//  Created by Arpit iOS Dev. on 06/06/24.
//

import Foundation
import UIKit
import Alamofire

// MARK: - Welcome
struct WeatherResponse: Decodable {
    let request: Request
    let location: Location
    let current: CurrentWeather
}

// MARK: - Current
struct CurrentWeather: Decodable {
    let observationTime: String
    let temperature, weatherCode: Int
    let weatherIcons: [String]
    let weatherDescriptions: [String]
    let windSpeed, windDegree: Int
    let windDir: String
    let pressure, precip, humidity, cloudcover: Int
    let feelslike, uvIndex, visibility: Int
    let isDay: String

    enum CodingKeys: String, CodingKey {
        case observationTime = "observation_time"
        case temperature
        case weatherCode = "weather_code"
        case weatherIcons = "weather_icons"
        case weatherDescriptions = "weather_descriptions"
        case windSpeed = "wind_speed"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case pressure, precip, humidity, cloudcover, feelslike
        case uvIndex = "uv_index"
        case visibility
        case isDay = "is_day"
    }
}

// MARK: - Location
struct Location: Decodable {
    let name, country, region, lat: String
    let lon, timezoneID, localtime: String
    let localtimeEpoch: Int
    let utcOffset: String

    enum CodingKeys: String, CodingKey {
        case name, country, region, lat, lon
        case timezoneID = "timezone_id"
        case localtime
        case localtimeEpoch = "localtime_epoch"
        case utcOffset = "utc_offset"
    }
}

// MARK: - Request
struct Request: Decodable {
    let type, query, language, unit: String
}



