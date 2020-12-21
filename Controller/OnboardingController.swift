//
//  OnboardingController.swift
//  weather
//
//  Created by Will on 12/14/20.
//  Copyright © 2020 Will. All rights reserved.
//

import UIKit
import SnapKit
import CoreLocation

class OnboardingController: UIViewController, CLLocationManagerDelegate {
	
	
	let locationManager = CLLocationManager()
	var currentLocation : CLLocation?
	
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		if locationManager.authorizationStatus == .authorizedAlways {
			presentWeatherController()
		} else if locationManager.authorizationStatus == .authorizedWhenInUse {
			presentWeatherController()
		} else {
			createAlert(title: "Location Permissions Disabled", message: "You have disabled location permissions for this app. You will only be able to search for locations. To fix this please visit your devices privacy settings for this application", style: .alert)
		}
	}
	
	private func presentWeatherController() {
			let vc = CurrentWeatherController()
			vc.modalPresentationStyle = .overFullScreen
			self.present(vc, animated: true, completion: nil)
	}

	private func createAlert(title: String, message: String, style: UIAlertController.Style) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
		alertController.addAction(UIAlertAction(title: "I Understand", style: .destructive))
		self.present(alertController, animated: true, completion: nil)
	}
	
	@objc func searchTapped() {
		let vc = SearchCityController()
		vc.modalPresentationStyle = .overFullScreen
		self.present(vc, animated: true, completion: nil)
	}
	
	private let label : UILabel = {
		let label = UILabel()
		label.text = "Please enable location services for this application in your settings.\n\n Settings \n Privacy \n Location Services \n Current Weather - Weather App \n Allow while using app"
		label.textColor = .white
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 18, weight: .semibold)
		label.numberOfLines = 20
		return label
	}()
	
	private let searchButton : UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Search", for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 22, weight: .regular)
		button.titleLabel?.textAlignment = .center
		button.backgroundColor = .white
		button.titleLabel?.textColor = .systemBlue
		button.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
		button.layer.cornerRadius = 10
		return button
	}()
	
	private func createView() {
		view.addSubview(label)
		view.addSubview(searchButton)
		
		label.snp.makeConstraints { (make) in
			make.width.equalTo(view.snp.width).offset(-20)
			make.centerX.equalTo(view.snp.centerX)
			make.top.equalTo(view.snp.topMargin).offset(80)
		}
		
		searchButton.snp.makeConstraints { (make) in
			make.width.equalTo(120)
			make.height.equalTo(40)
			make.centerX.equalTo(view.snp.centerX)
			make.top.equalTo(label.snp.bottom).offset(100)
		}
	}
    override func viewDidLoad() {
			super.viewDidLoad()
			view.backgroundColor = .systemBlue
			createView()
			locationManager.delegate = self
			locationManager.requestWhenInUseAuthorization()
        // Do any additional setup after loading the view.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}

}
