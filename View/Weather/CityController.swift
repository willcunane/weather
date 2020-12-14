//
//  Current.swift
//  weather
//
//  Created by Will on 7/28/20.
//  Copyright © 2020 Will. All rights reserved.
//

import Foundation
import SnapKit

public class CityController: UIViewController {
	
	weak var collectionView: UICollectionView!
	public static let shared = CityController()
	public var searchLocation : String?

	var Forecast : [Forecast] = []
	
	public override func loadView() {
		super.loadView()
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
		self.view.addSubview(collectionView)
		
		collectionView.snp.makeConstraints { (make) in
			make.top.equalTo(view.snp.top).offset(400)
			make.bottom.equalTo(view.snp.bottom).offset(-160)
			make.trailing.equalTo(view.snp.trailing).offset(5)
			make.leading.equalTo(view.snp.leading).offset(-5)
		}
		self.collectionView = collectionView
		collectionView.layer.borderWidth = 1
		collectionView.layer.borderColor = UIColor.white.cgColor
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		configureCollectionView()
		view.backgroundColor = .systemBlue
	}
	
	public override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		getWeatherBySearch(Location: searchLocation!)
		showLoading()
	}
	
	// Inits collection view
	private func configureCollectionView() {
		self.collectionView.dataSource = self
		self.collectionView.delegate = self
		self.collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
		self.collectionView.alwaysBounceVertical = true
		self.collectionView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
	}
	
	func getWeatherBySearch(Location : String){
		YahooWeatherAPI.shared.weather(location: Location, failure: { (error) in
			print(error.localizedDescription)
		}, success: { (response) in
			let data = response.data
			do {
				let entries = try JSONDecoder().decode(Weather.self, from: data)
				for days in entries.forecasts {
					self.Forecast.append(days)
				}
				self.createViewWithData(
					location: entries.location.city,
					summary: entries.currentObservation.condition.text,
					temperature: entries.currentObservation.condition.temperature,
					wind: entries.currentObservation.wind.speed,
					humidity: entries.currentObservation.atmosphere.humidity,
					sunrise: entries.currentObservation.astronomy.sunrise,
					sunset: entries.currentObservation.astronomy.sunset)
				self.updateIconImage(weatherCode: entries.currentObservation.condition.code, imageView: self.currentWeatherImage)
				self.collectionView.reloadData()
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
	
	// MARK: - UI Elements
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
	
	// MARK: - Constraints
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
			make.height.equalTo(30)
			make.centerX.equalTo(view.snp.centerX)
			make.bottom.equalTo(currentWeatherImage.snp.bottom)
		}
		currentWeatherImage.snp.makeConstraints { (make) in
			make.width.equalTo(250)
			make.height.equalTo(250)
			make.top.equalTo(locationLabel.snp.bottom)
			make.centerX.equalTo(view.snp.centerX)
		}
		currentTemperatureLabel.snp.makeConstraints { (make) in
			make.width.equalTo(120)
			make.height.equalTo(50)
			make.top.equalTo(currentWeatherImage.snp.bottom)
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
	}
}

extension CityController: UICollectionViewDataSource {
	
	public func collectionView(_ collectionView: UICollectionView,
											numberOfItemsInSection section: Int) -> Int {
		return Forecast.count
	}
	
	public func collectionView(_ collectionView: UICollectionView,
											cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as! Cell
		let data = self.Forecast[indexPath.item]
		var day = data.day
		
		if day == "Mon" {
			day = "Monday"
		} else if day == "Tue" {
			day = "Tuesday"
		} else if day == "Wed" {
			day = "Wednesday"
		} else if day == "Thu" {
			day = "Thursday"
		} else if day == "Fri" {
			day = "Friday"
		} else if day == "Sat" {
			day = "Saturday"
		} else if day == "Sun" {
			day = "Sunday"
		}
		
		cell.textLabel.text = day
		cell.tempLabel.text = "\(Int(data.high))° | \(Int(data.low))°"
		updateIconImage(weatherCode: Double(data.code), imageView: cell.weatherIcon)
		return cell
	}
}

extension CityController: UICollectionViewDelegate {
	
	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
	}
}

extension CityController: UICollectionViewDelegateFlowLayout {
	
	public func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.bounds.width, height: 70)
	}
	
	public func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) //.zero
	}
	
	public func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	public func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
}
