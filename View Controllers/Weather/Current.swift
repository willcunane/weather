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

class CurrentWeatherController: UIViewController, CLLocationManagerDelegate {
	
	let locationManager = CLLocationManager()	
	var currentLocation : CLLocation?
	var Forecast : [Forecast] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		view.backgroundColor = .systemBlue
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setupLocation()
		showLoading()
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if !locations.isEmpty, currentLocation == nil {
			currentLocation = locations.first
			locationManager.stopUpdatingLocation()
			getWeatherForLocation()
		}
	}
	
	func setupLocation() {
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
	}

	func getWeatherForLocation() {
		guard let currentLocation = currentLocation else {return}
		let lat = currentLocation.coordinate.latitude
		let long = currentLocation.coordinate.longitude
		print("Longitude:\(long), Latitude:\(lat)")
		YahooWeatherAPI.shared.weather(lat: "\(lat)", lon: "\(long)", failure: { (error) in
			print(error.localizedDescription)
		}, success: { (response) in
			let data = response.data
			do {
				let entries = try JSONDecoder().decode(Weather.self, from: data)
				for x in entries.forecasts {
					self.Forecast.append(x)
				}
				self.createViewWithData(
					location: entries.location.city,
					summary: entries.currentObservation.condition.text,
					temperature: entries.currentObservation.condition.temperature,
					wind: entries.currentObservation.wind.speed,
					humidity: entries.currentObservation.atmosphere.humidity,
					sunrise: entries.currentObservation.astronomy.sunrise,
					sunset: entries.currentObservation.astronomy.sunset
				)
				print(entries.currentObservation.condition.code)
				self.updateIconImage(weatherCode: entries.currentObservation.condition.code)
				self.removeLoading()
			} catch {
				print(error)
			}
		}, responseFormat: .json, unit: .imperial)
	}
	
	func createViewWithData(location: String?, summary: String?, temperature: Double?, wind: Double?, humidity: Double?, sunrise: String?, sunset: String?) {
		configureViewComponents()
		configureViewLayout()
		
		locationLabel.text = location
		summaryLabel.text = summary
		currentTemperatureLabel.text = "\(Int(temperature!))°"
		windSpeedLabel.text = "Wind Speed: \(Int(wind!)) mph"
		humidityLabel.text = "Humidity: \(Int(humidity!))%"
		sunriseLabel.text = "☀️ \(sunrise!) 🌕 \(sunset!)"
		removeLoading()
	}
	
	func updateIconImage(weatherCode: Double?){
		let code = Int(weatherCode!)
		// should this be a switch statement?
		print(code)
		if rainArray.contains(code){
			currentWeatherImage.image = #imageLiteral(resourceName: "rain")
		} else if cloudyArray.contains(code){
			currentWeatherImage.image = #imageLiteral(resourceName: "cloudy")
		} else if snowArray.contains(code){
			currentWeatherImage.image = #imageLiteral(resourceName: "snow")
		} else if sunnyArray.contains(code){
			currentWeatherImage.image = #imageLiteral(resourceName: "sunny")
		} else if stormArray.contains(code){
			currentWeatherImage.image = #imageLiteral(resourceName: "storm")
		} else {
			currentWeatherImage.image = #imageLiteral(resourceName: "cloudy")
		}
	}
	
	// Create view
	private let locationLabel : UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 30, weight: .medium)
		label.textColor = .white
		label.textAlignment = .center
		return label
	}()
	
	private let summaryLabel : UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 18, weight: .regular)
		label.textColor = .white
		label.textAlignment = .center
		return label
	}()
	
	private let currentWeatherImage : UIImageView = {
		let imageView = UIImageView()
		return imageView
	}()
	
	private let currentTemperatureLabel : UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 50, weight: .bold)
		label.textColor = .white
		return label
	}()
	
	private let windSpeedLabel : UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = .systemFont(ofSize: 22, weight: .bold)
		label.textColor = .white
		label.numberOfLines = 2
		return label
	}()
	
	private let humidityLabel : UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = .systemFont(ofSize: 22, weight: .bold)
		label.textColor = .white
		return label
	}()
	
	private let sunriseLabel : UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = .systemFont(ofSize: 26, weight: .bold)
		label.textColor = .white
		return label
	}()
	
	func configureViewComponents() {
		view.addSubview(currentWeatherImage)
		view.addSubview(currentTemperatureLabel)
		view.addSubview(windSpeedLabel)
		view.addSubview(humidityLabel)
		view.addSubview(locationLabel)
		view.addSubview(summaryLabel)
		view.addSubview(sunriseLabel)
	}
	
	// Create constraints for the view
	func configureViewLayout() {
		locationLabel.snp.makeConstraints { (make) in
			make.width.equalTo(300)
			make.height.equalTo(40)
			make.top.equalTo(50)
			make.centerX.equalTo(view.snp.centerX)
		}
		summaryLabel.snp.makeConstraints { (make) in
			make.width.equalTo(400)
			make.height.equalTo(50)
			make.top.equalTo(locationLabel.snp.bottom)
			make.centerX.equalTo(view.snp.centerX)
		}
		currentWeatherImage.snp.makeConstraints { (make) in
			make.width.equalTo(150)
			make.height.equalTo(150)
			make.top.equalTo(summaryLabel.snp.bottom).offset(30)
			make.centerX.equalTo(view.snp.centerX)
		}
		currentTemperatureLabel.snp.makeConstraints { (make) in
			make.width.equalTo(120)
			make.height.equalTo(70)
			make.top.equalTo(currentWeatherImage.snp.bottom).offset(10)
			make.centerX.equalTo(view.snp.centerX)
		}
		windSpeedLabel.snp.makeConstraints { (make) in
			make.width.equalTo(400)
			make.height.equalTo(50)
			make.leading.equalTo(view.snp.leading).offset(20)
			make.top.equalTo(currentTemperatureLabel.snp.bottom).offset(10)
		}
		humidityLabel.snp.makeConstraints { (make) in
			make.width.equalTo(400)
			make.height.equalTo(50)
			make.leading.equalTo(windSpeedLabel.snp.leading)
			make.top.equalTo(windSpeedLabel.snp.bottom)
		}
		sunriseLabel.snp.makeConstraints { (make) in
			make.width.equalTo(400)
			make.height.equalTo(50)
			make.leading.equalTo(windSpeedLabel.snp.leading)
			make.top.equalTo(humidityLabel.snp.bottom)
		}
	}

}
