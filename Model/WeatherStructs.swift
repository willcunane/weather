//
//  DataClasses.swift
//  AR Measure
//
//  Created by Will on 9/5/19.
//  Copyright © 2019 Will Cunane. All rights reserved.
//

import Foundation
import UIKit

struct Weather: Codable {
	let location: Location
	let currentObservation: CurrentObservation
	let forecasts: [Forecast]
	
	enum CodingKeys: String, CodingKey {
		case location
		case currentObservation = "current_observation"
		case forecasts
	}
}

struct CurrentObservation: Codable {
	let wind: Wind
	let atmosphere: Atmosphere
	let astronomy: Astronomy
	let condition: Condition
	let pubDate: Int
}

struct Astronomy: Codable {
	let sunrise, sunset: String
}

struct Atmosphere: Codable {
	let humidity, visibility: Double
	let pressure: Double
}

struct Condition: Codable {
	let text: String
	let code, temperature: Double
}

struct Wind: Codable {
	let chill, direction: Double
	let speed: Double
}

// MARK: - Forecast
struct Forecast: Codable {
	let day: String
	let date, low, high: Double
	let text: String
	let code: Int
}

struct Location: Codable {
	let woeid: Int
	let city, region, country: String
	let lat, long: Double
	let timezoneID: String
	
	enum CodingKeys: String, CodingKey {
		case woeid, city, region, country, lat, long
		case timezoneID = "timezone_id"
	}
}
