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

class WeeklyWeatherController: UIViewController, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
	
	weak var collectionView: UICollectionView!
	
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
		self.collectionView.dataSource = self
		self.collectionView.delegate = self
		self.collectionView.register(ForecastCell.self, forCellWithReuseIdentifier: ForecastCell.reuseId)
		self.collectionView.alwaysBounceVertical = true
		self.collectionView.backgroundColor = .red
		view.backgroundColor = .systemBlue
		configureViewLayout()
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
		collectionView.snp.makeConstraints { (make) in
			make.width.equalTo(view.snp.width)
			make.height.equalTo(view.snp.height)
		}
	}


}

class ForecastCell: UICollectionViewCell {

	weak var temperatureLabel: UILabel!
	weak var highLowLabel: UILabel!
	weak var dayLabel: UILabel!
	weak var weatherIcon: UIImageView!

	public static var reuseId : String = "forecastCell"

	override init(frame: CGRect) {
		super.init(frame: frame)

		let temperatureLabel = UILabel(frame: .zero)
		temperatureLabel.snp.makeConstraints { (make) in
			make.centerX.equalTo(temperatureLabel.snp.centerX)
			make.centerY.equalTo(temperatureLabel.snp.centerY)
		}
		self.temperatureLabel = temperatureLabel
		self.reset()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func reset() {
			self.temperatureLabel.textAlignment = .center
	}
}

class BlankCell: UICollectionViewCell {

	weak var titleLabel: UILabel!

	public static var reuseId: String = "forecastCell"
}

