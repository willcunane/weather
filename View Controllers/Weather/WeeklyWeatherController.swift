//
//  ViewController.swift
//  weather
//
//  Created by Will on 10/11/20.
//  Copyright © 2020 Will. All rights reserved.
//

import UIKit
import CoreLocation
import SnapKit

class WeeklyWeatherController: UIViewController, CLLocationManagerDelegate {
	
	weak var collectionView: UICollectionView!
	
	let locationManager = CLLocationManager()
	var currentLocation : CLLocation?
	var Forecast : [Forecast] = []
	
	override func loadView() {
		super.loadView()
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
		self.view.addSubview(collectionView)
		
		collectionView.snp.makeConstraints { (make) in
			make.top.equalTo(view.snp.top)
			make.bottom.equalTo(view.snp.bottom)
			make.trailing.equalTo(view.snp.trailing)
			make.leading.equalTo(view.snp.leading)
		}
		self.collectionView = collectionView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(pageCounter)
		createSwipeDirections()
		
		pageCounter.snp.makeConstraints { (make) in
			make.width.equalTo(50)
			make.height.equalTo(15)
			make.centerX.equalTo(view.snp.centerX)
			make.bottom.equalTo(view.snp.bottom).offset(-40)
		}
		
		self.collectionView.dataSource = self
		self.collectionView.delegate = self
		self.collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
		self.collectionView.alwaysBounceVertical = true
		self.collectionView.backgroundColor = .systemBlue
	}
	
	private let pageCounter : UIPageControl = {
		let counter = UIPageControl()
		counter.numberOfPages = 2
		counter.currentPage = 1
		return counter
	}()
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setupLocation()
		showLoading()
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
				self.collectionView.reloadData()
				self.removeLoading()
			} catch {
				print(error)
			}
		}, responseFormat: .json, unit: .imperial)
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
					case UISwipeGestureRecognizer.Direction.right:
						pageCounter.currentPage = 1
						presentToLeft(vc: CurrentWeatherController())
					default:
							break
					}
			}
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
}

extension WeeklyWeatherController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView,
											numberOfItemsInSection section: Int) -> Int {
		return Forecast.count
	}
	
	func collectionView(_ collectionView: UICollectionView,
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
		cell.tempLabel.text = "\(Int(data.low))° | \(Int(data.high))°"
		updateIconImage(weatherCode: Double(data.code), imageView: cell.weatherIcon)
		return cell
	}
}

extension WeeklyWeatherController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
	}
}

extension WeeklyWeatherController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.bounds.width, height: 70)
	}
	
	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) //.zero
	}
	
	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
}

class Cell: UICollectionViewCell {
	
	static var identifier: String = "Cell"
	
	weak var textLabel: UILabel!
	weak var tempLabel: UILabel!
	weak var weatherIcon: UIImageView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)

		let textLabel = UILabel(frame: .zero)
		textLabel.textColor = .white
		self.contentView.addSubview(textLabel)
		
		let tempLabel = UILabel(frame: .zero)
		tempLabel.textColor = .white
		self.contentView.addSubview(tempLabel)
		
		let weatherIcon = UIImageView(frame: .zero)
		self.contentView.addSubview(weatherIcon)
		
		textLabel.snp.makeConstraints { (make) in
			make.leading.equalTo(20)
			make.centerY.equalTo(self.snp.centerY)
			make.width.equalTo(100)
		}
		tempLabel.snp.makeConstraints { (make) in
			make.trailing.equalTo(-20)
			make.centerY.equalTo(self.snp.centerY)
			make.width.equalTo(80)
		}
		weatherIcon.snp.makeConstraints { (make) in
			make.width.equalTo(50)
			make.height.equalTo(50)
			make.centerY.equalTo(self.snp.centerY)
			make.centerX.equalTo(self.snp.centerX)
		}
		self.textLabel = textLabel
		self.tempLabel = tempLabel
		self.weatherIcon = weatherIcon
		self.reset()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		self.reset()
	}
	
	func reset() {
		self.textLabel.textAlignment = .left
		self.tempLabel.textAlignment = .left
		
		self.textLabel.font = .systemFont(ofSize: 18, weight: .bold)
		self.tempLabel.font = .systemFont(ofSize: 18, weight: .bold)
	}
}


