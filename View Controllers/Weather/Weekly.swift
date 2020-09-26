//
//  Weekly.swift
//  weather
//
//  Created by Will on 7/28/20.
//  Copyright © 2020 Will. All rights reserved.
//

import Foundation
import SnapKit
import CoreLocation

class WeeklyWeatherController: UIViewController, CLLocationManagerDelegate {
	
	let locationManager = CLLocationManager()
	var currentLocation : CLLocation?
	var Forecast : [Forecast] = []

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return Forecast.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCell.reuseId, for: indexPath) as? ForecastCell else {
			return collectionView.dequeueReusableCell(withReuseIdentifier: BlankCell.reuseId, for: indexPath)
		}
		
		return cell
	}
	

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
				// Do stuff with data
			} catch {
				print(error)
			}
		}, responseFormat: .json, unit: .imperial)
	}
	
	func configureViewLayout(){
		
	}


}

class ForecastCell: UICollectionViewCell {
	
	weak var temperatureLabel: UILabel!
	weak var highLowLabel: UILabel!
	weak var dayLabel: UILabel!
	weak var weatherIcon: UIImageView!
	
	public static var reuseId : String = "forecastCell"
}

class BlankCell: UICollectionViewCell {
	
	weak var titleLabel: UILabel!
	
	public static var reuseId: String = "forecastCell"
}

