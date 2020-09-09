//
//  Onboarding.swift
//  weather
//
//  Created by Will on 7/28/20.
//  Copyright © 2020 Will. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import CoreLocation

class OnboardingController : UIViewController, CLLocationManagerDelegate {
	
	var currentLocation: CLLocation?
	let locationManager = CLLocationManager()
	
	func setupLocation() {
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if locations.isEmpty, currentLocation == nil {
			currentLocation = locations.first
			locationManager.stopUpdatingLocation()
		}
	}
	
	func isLocationServiceEnabled() -> Bool {
			if CLLocationManager.locationServicesEnabled() {
					switch(CLLocationManager.authorizationStatus()) {
					case .notDetermined, .restricted, .denied:
							return false
					case .authorizedAlways, .authorizedWhenInUse:
							return true
					default:
							print("Something wrong with Location services")
							return false
					}
			} else {
					print("Location services are not enabled")
					return false
			}
	}
	
	override func viewDidLoad(){
		super.viewDidLoad()
		createLayout()
		setupLocation()
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		if isLocationServiceEnabled() == true {
				locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
				locationManager.startUpdatingLocation()
			let vc = CustomTabBarController()
			vc.modalPresentationStyle = .overFullScreen
			self.present(vc, animated: true, completion: nil)
		}
	}
	
	private let displayImage : UIImageView = {
		let imageView = UIImageView()
		let imageName = "iconfinder_Weather_669958.png"
		let image = UIImage(named: imageName)
		imageView.image = image
		return imageView
	}()
	
	private let displayText : UILabel = {
		let label = UILabel()
		label.text = "Please allow us to use your location to track the weather in your area."
		label.numberOfLines = 5
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 22, weight: .semibold)
		label.textColor = .systemBlue
		return label
	}()
	
	func createLayout() {
		view.backgroundColor = .white
		view.addSubview(displayText)
		view.addSubview(displayImage)
		
		displayImage.snp.makeConstraints { (make) in
			make.width.equalTo(300)
			make.height.equalTo(300)
			make.centerX.equalTo(view.snp.centerX)
			make.top.equalTo(view.snp.top).offset(70)
		}
		
		displayText.snp.makeConstraints { (make) in
			make.width.equalTo(300)
			make.height.equalTo(200)
			make.centerX.equalTo(view.snp.centerX)
			make.top.equalTo(displayImage.snp.bottom).offset(50)
		}
	}
}
