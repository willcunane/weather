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
		
		let layout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
		layout.scrollDirection = .horizontal
		layout.itemSize = CGSize(width: 150, height: 250)
		
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.alwaysBounceHorizontal = true
		collectionView.bounces = false
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.contentInset = UIEdgeInsets(top: -10, left: 0, bottom:0, right: 0)
		
		self.view.addSubview(collectionView)
		
		collectionView.snp.makeConstraints { (make) in
			make.top.equalTo(view.snp.top).offset(530)
			make.bottom.equalTo(view.snp.bottomMargin).offset(-20)
			make.trailing.equalTo(view.snp.trailing)
			make.leading.equalTo(view.snp.leading)
		}
		self.collectionView = collectionView
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		configureCollectionView()
		view.backgroundColor = primaryColor
		configureSwipeDirections()
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
		self.collectionView.backgroundColor = primaryColor
	}
	
	// Inits swipe direction and action
	func configureSwipeDirections() {
		let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
		swipeDown.direction = .up
		self.view.addGestureRecognizer(swipeDown)
	}
	@objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
		if let swipeGesture = gesture as? UISwipeGestureRecognizer {
			switch swipeGesture.direction {
			case UISwipeGestureRecognizer.Direction.up:
				let vc = SearchCityController()
				vc.modalPresentationStyle = .overFullScreen
				self.present(vc, animated: true, completion: nil)
			default:
				break
			}
		}
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
		windSpeedLabel.text = "\(Int(wind!)) mph"
		humidityLabel.text = "\(Int(humidity!))%"
		sunriseLabel.text = "\(sunrise!)"
		sunsetLabel.text = "\(sunset!)"
		removeLoading()
	}
	
	// MARK: - UI Elements
	private let locationImage : UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.image = #imageLiteral(resourceName: "newLocation")
		imageView.image?.withRenderingMode(.alwaysTemplate)
		imageView.tintColor = UIColor.white
		return imageView
	}()
	
	private let locationLabel : UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 30, weight: .semibold)
		label.textColor = textColor
		label.textAlignment = .left
		return label
	}()
	
	private let summaryLabel : UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 18, weight: .semibold)
		label.textColor = textColor
		label.textAlignment = .center
		return label
	}()
	
	private let currentWeatherImage : UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	private let sunriseIconImage : UIImageView = {
		let imageView = UIImageView()
		imageView.image = #imageLiteral(resourceName: "newSunset")
		imageView.tintColor = secondaryColor
		return imageView
	}()
	
	private let sunsetIconImage : UIImageView = {
		let imageView = UIImageView()
		imageView.image = #imageLiteral(resourceName: "newSunrise")
		return imageView
	}()
	
	private let currentTemperatureLabel : UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 56, weight: .bold)
		label.textColor = textColor
		return label
	}()
	
	private let humidityIcon : UIImageView = {
		let imageView = UIImageView()
		imageView.image = #imageLiteral(resourceName: "newHumidity")
		return imageView
	}()
	
	private let windSpeedIcon : UIImageView = {
		let imageView = UIImageView()
		imageView.image = #imageLiteral(resourceName: "newWindSPeed")
		return imageView
	}()
	
	private let windSpeedLabel : UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 16, weight: .semibold)
		label.textColor = textColor
		label.numberOfLines = 2
		return label
	}()
	
	private let humidityLabel : UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 16, weight: .semibold)
		label.textColor = textColor
		return label
	}()
	
	private let sunriseLabel : UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 16, weight: .semibold)
		label.textColor = textColor
		return label
	}()
	private let sunsetLabel : UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 16, weight: .semibold)
		label.textColor = textColor
		return label
	}()
	
	// MARK: - Constraints
	func configureViewComponents() {
		view.addSubview(locationImage)
		view.addSubview(currentWeatherImage)
		view.addSubview(currentTemperatureLabel)
		view.addSubview(humidityIcon)
		view.addSubview(windSpeedIcon)
		view.addSubview(windSpeedLabel)
		view.addSubview(humidityLabel)
		view.addSubview(locationLabel)
		view.addSubview(summaryLabel)
		view.addSubview(sunriseLabel)
		view.addSubview(sunsetLabel)
		view.addSubview(sunriseIconImage)
		view.addSubview(sunsetIconImage)
	}
	
	// Create constraints for the view
	func configureViewLayout() {
		locationImage.snp.makeConstraints { (make) in
			make.width.equalTo(30)
			make.height.equalTo(30)
			make.centerY.equalTo(locationLabel.snp.centerY)
			make.trailing.equalTo(locationLabel.snp.leading).offset(-20)
		}
		locationLabel.snp.makeConstraints { (make) in
			make.width.equalTo(300)
			make.height.equalTo(40)
			make.top.equalTo(50)
			make.leading.equalTo(view.snp.leading).offset(80)
		}
		summaryLabel.snp.makeConstraints { (make) in
			make.width.equalTo(200)
			make.height.equalTo(30)
			make.centerX.equalTo(view.snp.centerX)
			make.top.equalTo(currentWeatherImage.snp.bottom).offset(20)
		}
		currentWeatherImage.snp.makeConstraints { (make) in
			make.width.equalTo(200)
			make.height.equalTo(180)
			make.top.equalTo(locationLabel.snp.bottom).offset(30)
			make.centerX.equalTo(view.snp.centerX)
		}
		currentTemperatureLabel.snp.makeConstraints { (make) in
			make.width.equalTo(120)
			make.height.equalTo(50)
			make.top.equalTo(summaryLabel.snp.bottom).offset(5)
			make.centerX.equalTo(view.snp.centerX)
		}
		sunriseIconImage.snp.makeConstraints { (make) in
			make.width.equalTo(40)
			make.height.equalTo(40)
			make.top.equalTo(currentTemperatureLabel.snp.bottom).offset(50)
			make.centerX.equalTo(sunriseLabel.snp.centerX)
		}
		sunriseLabel.snp.makeConstraints { (make) in
			make.width.equalTo(80)
			make.height.equalTo(30)
			make.top.equalTo(sunriseIconImage.snp.bottom)
			make.leading.equalTo(view.snp.leading).offset(10)
		}
		humidityIcon.snp.makeConstraints { (make) in
			make.width.equalTo(40)
			make.height.equalTo(40)
			make.top.equalTo(sunriseIconImage.snp.top)
			make.centerX.equalTo(humidityLabel.snp.centerX)
		}
		humidityLabel.snp.makeConstraints { (make) in
			make.width.equalTo(80)
			make.height.equalTo(30)
			make.top.equalTo(humidityIcon.snp.bottom)
			make.leading.equalTo(sunriseLabel.snp.trailing).offset(30)
		}
		windSpeedIcon.snp.makeConstraints { (make) in
			make.width.equalTo(40)
			make.height.equalTo(40)
			make.top.equalTo(sunriseIconImage.snp.top)
			make.centerX.equalTo(windSpeedLabel.snp.centerX)
		}
		windSpeedLabel.snp.makeConstraints { (make) in
			make.width.equalTo(80)
			make.height.equalTo(30)
			make.top.equalTo(windSpeedIcon.snp.bottom)
			make.trailing.equalTo(sunsetLabel.snp.leading).offset(-30)
		}
		sunriseIconImage.snp.makeConstraints { (make) in
			make.width.equalTo(40)
			make.height.equalTo(40)
			make.top.equalTo(currentTemperatureLabel.snp.bottom).offset(70)
			make.centerX.equalTo(sunriseLabel.snp.centerX)
		}
		sunsetIconImage.snp.makeConstraints { (make) in
			make.width.equalTo(40)
			make.height.equalTo(40)
			make.top.equalTo(sunriseIconImage.snp.top)
			make.centerX.equalTo(sunsetLabel.snp.centerX)
		}
		sunsetLabel.snp.makeConstraints { (make) in
			make.width.equalTo(80)
			make.height.equalTo(30)
			make.top.equalTo(sunsetIconImage.snp.bottom)
			make.trailing.equalTo(view.snp.trailing).offset(-10)
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
		
		cell.backgroundColor = cellBackgroundColor.withAlphaComponent(0.3)
		cell.layer.cornerRadius = 10
		
		return cell
	}
}

extension CityController: UICollectionViewDelegate {
	
	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
	}
}

