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

public class CurrentWeatherController: UIViewController, CLLocationManagerDelegate {
	
	weak var collectionView: UICollectionView!
	
	let locationManager = CLLocationManager()	
	var currentLocation : CLLocation?
	var Forecast : [Forecast] = []
	private var animationLoopCount : Int = 0
	
	public static let shared = CurrentWeatherController()
	
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
		configureSwipeDirections()
		view.backgroundColor = primaryColor
	}
	
	public override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		determineLocationPermissions()
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
				removeSwipeAlert()
			default:
				break
			}
		}
	}
	
	// Location listener
	public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if !locations.isEmpty, currentLocation == nil {
			currentLocation = locations.first
			locationManager.stopUpdatingLocation()
			getWeatherByLocation()
		}
	}
	
	private func determineLocationPermissions() {
		locationManager.delegate = self
		if CLLocationManager.locationServicesEnabled() {
			switch CLLocationManager.authorizationStatus() {
			case .notDetermined:
				locationManager.requestWhenInUseAuthorization()
			case .authorizedWhenInUse:
				locationManager.startUpdatingLocation()
			case .restricted:
				// Best practice would be to present a view controller, since this is a demo app I'm assuming this will not happen
				self.dismiss(animated: true, completion: nil)
				print("Location not allowed, please change this in your settings")
			default:
				print("Location permissions not determined")
			}
		}
	}
	
	private func getWeatherByLocation() {
		guard let currentLocation = currentLocation else {return}
		let lat = currentLocation.coordinate.latitude
		let long = currentLocation.coordinate.longitude
		YahooWeatherAPI.shared.weather(lat: "\(lat)", lon: "\(long)", failure: { (error) in
			print(error.localizedDescription)
		}, success: { (response) in
			let data = response.data
			do {
				let entries = try JSONDecoder().decode(Weather.self, from: data)
				for days in entries.forecasts {
					self.Forecast.append(days)
				}
				self.configureViewComponents()
				self.configureViewLayout()
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
				self.collectionView.reloadData()
				self.removeLoading()
			} catch {
				print(error)
			}
		}, responseFormat: .json, unit: .imperial)
	}
	
	func getWeatherBySearch(Location : String){
		YahooWeatherAPI.shared.weather(location: Location, failure: { (error) in
			print(error.localizedDescription)
		}, success: { (response) in
			let data = response.data
			do {
				let entries = try JSONDecoder().decode(Weather.self, from: data)
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
		animateSwipeAlertOut()
		
		locationLabel.text = location
		summaryLabel.text = summary
		currentTemperatureLabel.text = "\(Int(temperature!))°"
		windSpeedLabel.text = "Wind Speed: \(Int(wind!)) mph"
		humidityLabel.text = "Humidity: \(Int(humidity!))%"
		sunriseLabel.text = "\(sunrise!)"
		sunsetLabel.text = "\(sunset!)"
		removeLoading()
	}
	
	private func animateSwipeAlertOut() {
		UIView.animate(withDuration: 2.5, animations: {
			self.upArrow.alpha = 0
			self.swipeUpLabel.alpha = 0
		}, completion: {_ in
			self.animateSwipeAlertIn()
		})
	}
	
	private func animateSwipeAlertIn() {
		if animationLoopCount <= 5 {
			animationLoopCount += 1
			UIView.animate(withDuration: 2.5, animations: {
				self.upArrow.alpha = 1
				self.swipeUpLabel.alpha = 1
			}, completion: {_ in
				self.animateSwipeAlertOut()
			})
		}
	}
	
	private func removeSwipeAlert() {
		self.upArrow.removeFromSuperview()
		self.swipeUpLabel.removeFromSuperview()
	}
	
	// MARK: - UI Elements
	private let locationLabel : UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 30, weight: .medium)
		label.textColor = textColor
		label.textAlignment = .center
		return label
	}()
	
	private let summaryLabel : UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 18, weight: .regular)
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
		label.font = .systemFont(ofSize: 56, weight: .bold)
		label.textColor = textColor
		return label
	}()
	
	private let windSpeedLabel : UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = .systemFont(ofSize: 22, weight: .bold)
		label.textColor = textColor
		label.numberOfLines = 2
		return label
	}()
	
	private let humidityLabel : UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = .systemFont(ofSize: 22, weight: .bold)
		label.textColor = textColor
		return label
	}()
	
	private let sunriseLabel : UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 22, weight: .bold)
		label.textColor = textColor
		return label
	}()
	private let sunsetLabel : UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 22, weight: .bold)
		label.textColor = textColor
		return label
	}()
	
	private let sunriseHeader : UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 20, weight: .regular)
		label.textColor = textColor
		label.text = ""
		return label
	}()
	
	private let sunsetHeader : UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 20, weight: .regular)
		label.textColor = textColor
		label.text = ""
		return label
	}()
	
	private let upArrow : UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "hand.point.up.left")
		imageView.tintColor = textColor
		return imageView
	}()
	
	private let swipeUpLabel : UILabel = {
		let label = UILabel()
		label.text = "Swipe up to search for a city"
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 14, weight: .regular)
		label.textColor = textColor
		label.numberOfLines = 2
		
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
		view.addSubview(upArrow)
		view.addSubview(swipeUpLabel)
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
			make.bottom.equalTo(collectionView.snp.top).offset(-10)
		}
		currentWeatherImage.snp.makeConstraints { (make) in
			make.width.equalTo(200)
			make.height.equalTo(180)
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
		upArrow.snp.makeConstraints { (make) in
			make.width.equalTo(50)
			make.height.equalTo(60)
			make.centerX.equalTo(view.snp.centerX)
			make.top.equalTo(collectionView.snp.bottom).offset(10)
		}
		swipeUpLabel.snp.makeConstraints { (make) in
			make.width.equalTo(180)
			make.height.equalTo(40)
			make.centerX.equalTo(view.snp.centerX)
			make.top.equalTo(upArrow.snp.bottom)
		}
	}
}
