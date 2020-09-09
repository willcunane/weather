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
	let rainArray : [Int] = [1,2,3,4,5,6,7,8,9,10]
	let cloudyArray : [Int] = [26,27,28,29,30]
	let snowArray : [Int] = [13,14,15,16]
	let sunnyArray : [Int] = [31,32,33,34]
	let stormArray : [Int] = [41,42,43,44,45,46,47]
	
	var currentLocation : CLLocation?
	var models = [Weather]()
	

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		view.backgroundColor = .systemBlue
//		createLayout()
//		setupLayout()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setupLocation()
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
				self.models.append(entries)
				print(entries.currentObservation)
				self.createViewWithData(location: entries.location.city, summary: entries.currentObservation.condition.text, weatherImage: #imageLiteral(resourceName: "iconfinder_Weather_669958"), temperature: entries.currentObservation.condition.temperature, wind: entries.currentObservation.wind.speed, humidity: entries.currentObservation.atmosphere.humidity)
			} catch {
				print(error)
			}
		}, responseFormat: .json, unit: .imperial)
	}
	
	func createViewWithData(location: String?, summary: String?, weatherImage: UIImage, temperature: Double?, wind: Double?, humidity: Double?) {
		createLayout()
		setupLayout()
		locationLabel.text = location
		summaryLabel.text = summary
		currentWeatherImage.image = weatherImage
		currentTemperatureLabel.text = "\(Int(temperature!))"
		windSpeedLabel.text = "\(Int(wind!))"
		humidityLabel.text = "\(Int(humidity!))"
		
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
		label.numberOfLines = 2
		return label
	}()
	
	private let currentWeatherImage : UIImageView = {
		let image = #imageLiteral(resourceName: "iconfinder_Weather_669958")
		let imageView = UIImageView.init(image: image)
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
		view.addSubview(locationLabel)
		view.addSubview(summaryLabel)
	}
	
	// Create constraints for the view
	func setupLayout() {
		locationLabel.snp.makeConstraints { (make) in
			make.width.equalTo(300)
			make.height.equalTo(60)
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
