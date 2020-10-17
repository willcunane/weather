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
		createSwipeDirections()
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
				self.updateIconImage(weatherCode: entries.currentObservation.condition.code, imageView: self.currentWeatherImage)
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
		sunriseLabel.text = "\(sunrise!)"
		sunsetLabel.text = "\(sunset!)"
		removeLoading()
	}
	
	func createSwipeDirections(){
		let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
		swipeRight.direction = UISwipeGestureRecognizer.Direction.right
    self.view.addGestureRecognizer(swipeRight)
		
		let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
		swipeRight.direction = UISwipeGestureRecognizer.Direction.left
    self.view.addGestureRecognizer(swipeLeft)
	}
	
	@objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
			if let swipeGesture = gesture as? UISwipeGestureRecognizer {
					switch swipeGesture.direction {
					case UISwipeGestureRecognizer.Direction.left:
						pageCounter.currentPage = 1
						presentToRight(vc: WeeklyWeatherController())
					default:
							break
					}
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
	
	private let sunriseIconImage : UIImageView = {
		let imageView = UIImageView()
		imageView.image = #imageLiteral(resourceName: "sunrise_icon")
		return imageView
	}()
	
	private let sunsetIconImage : UIImageView = {
		let imageView = UIImageView()
		imageView.image = #imageLiteral(resourceName: "sunset_icon")
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
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 22, weight: .bold)
		label.textColor = .white
		return label
	}()
	private let sunsetLabel : UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 22, weight: .bold)
		label.textColor = .white
		return label
	}()
	
	private let sunriseHeader : UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 20, weight: .regular)
		label.textColor = .white
		label.text = "Sunrise"
		return label
	}()
	
	private let sunsetHeader : UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 20, weight: .regular)
		label.textColor = .white
		label.text = "Sunset"
		return label
	}()
	
	private let pageCounter : UIPageControl = {
		let counter = UIPageControl()
		counter.numberOfPages = 2
		counter.currentPage = 0
		return counter
	}()
	
	func configureViewComponents() {
		view.addSubview(currentWeatherImage)
		view.addSubview(currentTemperatureLabel)
		view.addSubview(windSpeedLabel)
		view.addSubview(humidityLabel)
		view.addSubview(locationLabel)
		view.addSubview(summaryLabel)
		view.addSubview(sunriseLabel)
		view.addSubview(sunriseHeader)
		view.addSubview(sunsetHeader)
		view.addSubview(sunsetLabel)
		view.addSubview(sunriseIconImage)
		view.addSubview(sunsetIconImage)
		view.addSubview(pageCounter)
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
			make.width.equalTo(200)
			make.height.equalTo(50)
			make.centerX.equalTo(view.snp.centerX)
			make.bottom.equalTo(currentTemperatureLabel.snp.top).offset(5)
		}
		currentWeatherImage.snp.makeConstraints { (make) in
			make.width.equalTo(250)
			make.height.equalTo(250)
			make.top.equalTo(locationLabel.snp.bottom)
			make.centerX.equalTo(view.snp.centerX)
		}
		currentTemperatureLabel.snp.makeConstraints { (make) in
			make.width.equalTo(120)
			make.height.equalTo(70)
			make.top.equalTo(currentWeatherImage.snp.bottom).offset(10)
			make.centerX.equalTo(view.snp.centerX)
		}
		sunriseHeader.snp.makeConstraints { (make) in
			make.width.equalTo(80)
			make.height.equalTo(20)
			make.leading.equalTo(view.snp.leading).offset(20)
			make.bottom.equalTo(view.snp.bottomMargin).offset(-10)
		}
		sunsetHeader.snp.makeConstraints { (make) in
			make.width.equalTo(80)
			make.height.equalTo(20)
			make.trailing.equalTo(view.snp.trailing).offset(-20)
			make.bottom.equalTo(view.snp.bottomMargin).offset(-10)
		}
		sunriseLabel.snp.makeConstraints { (make) in
			make.width.equalTo(100)
			make.height.equalTo(30)
			make.bottom.equalTo(sunriseHeader.snp.top)
			make.centerX.equalTo(sunriseHeader.snp.centerX)
		}
		sunsetLabel.snp.makeConstraints { (make) in
			make.width.equalTo(100)
			make.height.equalTo(30)
			make.bottom.equalTo(sunsetHeader.snp.top)
			make.centerX.equalTo(sunsetHeader.snp.centerX)
		}
		sunsetIconImage.snp.makeConstraints { (make) in
			make.width.equalTo(50)
			make.height.equalTo(50)
			make.bottom.equalTo(sunsetLabel.snp.top)
			make.centerX.equalTo(sunsetLabel.snp.centerX)
		}
		sunriseIconImage.snp.makeConstraints { (make) in
			make.width.equalTo(50)
			make.height.equalTo(50)
			make.bottom.equalTo(sunriseLabel.snp.top)
			make.centerX.equalTo(sunriseLabel.snp.centerX)
		}
		pageCounter.snp.makeConstraints { (make) in
			make.width.equalTo(50)
			make.height.equalTo(15)
			make.centerX.equalTo(view.snp.centerX)
			make.bottom.equalTo(view.snp.bottom).offset(-40)
		}
	}

}
