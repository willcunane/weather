//
//  Current.swift
//  weather
//
//  Created by Will on 7/28/20.
//  Copyright © 2020 Will. All rights reserved.
//

import Foundation
import SnapKit
import CoreLocation

class CurrentWeatherController: UIViewController {
	
	let rainArray : [Int] = [1,2,3,4,5,6,7,8,9,10]
	let cloudyArray : [Int] = [26,27,28,29,30]
	let snowArray : [Int] = [13,14,15,16]
	let sunnyArray : [Int] = [31,32,33,34]
	let stormArray : [Int] = [41,42,43,44,45,46,47]

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		view.backgroundColor = .systemBlue
		createLayout()
		setupLayout()
		getWeather()
	}
	
	 func getWeather() {
				 YahooWeatherAPI.shared.weather(lat: "\(currentLat!)", lon: "\(currentLong!)", failure: { (error) in
						 print(error.localizedDescription)
						 print("Error pulling weather data")
				 }, success: { (response) in
						 let data = response.data
						 do {
								 let weather = try JSONDecoder().decode(Weather.self, from: data)
								 self.windSpeedLabel.text = "Wind Speed: \(weather.currentObservation.wind.speed) mph"
								 self.humidityLabel.text = "Humidity: \(weather.currentObservation.atmosphere.humidity)%"
								 self.currentTemperatureLabel.text = "\(weather.currentObservation.condition.temperature)°F"
								 //print(weather.currentObservation.condition.code)
								 if self.rainArray.contains(weather.currentObservation.condition.code) == true {
										 self.currentWeatherImage.image = UIImage(named: "Rain.png")
								 } else if self.snowArray.contains(weather.currentObservation.condition.code) == true {
										 self.currentWeatherImage.image = UIImage(named: "snow.png")
								 } else if self.cloudyArray.contains(weather.currentObservation.condition.code) == true {
										 self.currentWeatherImage.image = UIImage(named: "cloudy.png")
								 } else if self.sunnyArray.contains(weather.currentObservation.condition.code) == true {
										 self.currentWeatherImage.image = UIImage(named: "sunny.png")
								 } else if self.stormArray.contains(weather.currentObservation.condition.code) == true {
										 self.currentWeatherImage.image = UIImage(named: "storm.png")
								 } else {
										 self.currentWeatherImage.image = UIImage(named: "cloudy.png")
								 }
						 } catch {
								 print(error)
						 }
				 }, responseFormat: .json, unit: .imperial)
		 }
	
	private let currentWeatherImage : UIImageView = {
		let image = #imageLiteral(resourceName: "iconfinder_Weather_669958")
		let imageView = UIImageView.init(image: image)
		return imageView
	}()
	
	private let currentTemperatureLabel : UILabel = {
		let label = UILabel()
		label.text = "°F"
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 50, weight: .bold)
		label.textColor = .white
		return label
	}()
	
	private let windSpeedLabel : UILabel = {
		let label = UILabel()
		label.text = "mph."
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 22, weight: .bold)
		label.textColor = .white
		return label
	}()
	
	private let humidityLabel : UILabel = {
		let label = UILabel()
		label.text = ""
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 22, weight: .bold)
		label.textColor = .white
		return label
	}()
	
	func createLayout() {
		view.addSubview(currentWeatherImage)
		view.addSubview(currentTemperatureLabel)
		view.addSubview(windSpeedLabel)
		view.addSubview(humidityLabel)
	}
	
	func setupLayout() {
		currentWeatherImage.snp.makeConstraints { (make) in
			make.width.equalTo(250)
			make.height.equalTo(250)
			make.top.equalTo(50)
			make.centerX.equalTo(view.snp.centerX)
		}
		currentTemperatureLabel.snp.makeConstraints { (make) in
			make.width.equalTo(120)
			make.height.equalTo(70)
			make.top.equalTo(currentWeatherImage.snp.bottom).offset(10)
			make.centerX.equalTo(view.snp.centerX)
		}
		windSpeedLabel.snp.makeConstraints { (make) in
			make.width.equalTo(100)
			make.height.equalTo(60)
			make.centerX.equalTo(view.snp.centerX)
			make.top.equalTo(currentTemperatureLabel.snp.bottom).offset(10)
		}
		humidityLabel.snp.makeConstraints { (make) in
			make.width.equalTo(100)
			make.height.equalTo(60)
			make.centerX.equalTo(view.snp.centerX)
			make.top.equalTo(windSpeedLabel.snp.bottom).offset(10)
		}
	}

}
