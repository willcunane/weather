//
//  UpdatedOnboarding.swift
//  weather
//
//  Created by Will on 8/27/20.
//  Copyright © 2020 Will. All rights reserved.
//

import UIKit
import CoreLocation
import SnapKit

//var currentLong: Double!
//var currentLat: Double!

class UpdatedOnboarding: UIViewController, CLLocationManagerDelegate {
	
	let locationManager = CLLocationManager()
	var currentLocation : CLLocation?
//	var currentForecast : Weather?
//	var models = [Weather]()
	
    override func viewDidLoad() {
			super.viewDidLoad()
	//		setupLocation()
			view.addSubview(backgroundImage)
			createBlur()
			createView()
			// Do any additional setup after loading the view.
    }
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
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
		//		self.models.append(entries)
		//		print(entries.currentObservation)
			} catch {
				print(error)
			}
		}, responseFormat: .json, unit: .imperial)
	}

	private func createBlur() {
		let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = view.bounds
		blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		view.addSubview(blurEffectView)
	}
	
	private let allowButton : UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Allow", for: .normal)
		button.backgroundColor = .systemYellow
		button.addTarget(self, action: #selector(allowTapped), for: .touchUpInside)
		button.titleLabel?.font = .boldSystemFont(ofSize: 22)
		button.layer.cornerRadius = 10
		return button
	}()
	
	@objc func allowTapped() {
		let vc = CustomTabBarController()
		vc.modalPresentationStyle = .overFullScreen
		self.present(vc, animated: true, completion: nil)
	}
	
	func createView() {
		view.addSubview(promptText)
		view.addSubview(smallText)
		view.addSubview(allowButton)
		
		allowButton.snp.makeConstraints { (make) in
			make.width.equalTo(250)
			make.height.equalTo(60)
			make.centerY.equalTo(view.snp.centerY)
			make.centerX.equalTo(view.snp.centerX)
		}
		
		backgroundImage.snp.makeConstraints { (make) in
			make.width.equalTo(view.snp.width)
			make.height.equalTo(view.snp.height)
		}
		
		promptText.snp.makeConstraints { (make) in
			make.width.equalTo(view.snp.width)
			make.height.equalTo(300)
			make.top.equalTo(view.snp.topMargin).offset(100)
			make.centerX.equalTo(view.snp.centerX)
		}
		
		smallText.snp.makeConstraints { (make) in
			make.width.equalTo(300)
			make.height.equalTo(100)
			make.top.equalTo(promptText.snp.bottom)
			make.centerX.equalTo(view.snp.centerX)
		}

	}
	
	private let backgroundImage : UIImageView = {
		let image = UIImageView()
		image.image = #imageLiteral(resourceName: "background")
		return image
	}()
	
	private let promptText : UILabel = {
		let text = UILabel()
		text.font = .boldSystemFont(ofSize: 32)
		text.backgroundColor = .clear
		text.textColor = .white
		text.numberOfLines = 12
		text.textAlignment = .center
		text.text = "Please allow this app to access your location"
		return text
	}()
	private let smallText : UILabel = {
		let text = UILabel()
		text.font = .boldSystemFont(ofSize: 22)
		text.backgroundColor = .clear
		text.textColor = .white
		text.numberOfLines = 12
		text.textAlignment = .center
		text.text = "Settings > Privacy > Location Services > Weather App"
		return text
	}()
	
	
	
}
