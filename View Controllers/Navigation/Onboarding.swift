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

var currentLong: Double?
var currentLat: Double?

class OnboardingController : UIViewController, CLLocationManagerDelegate {
	
	let locationManager = CLLocationManager()
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
			currentLong = locations.last?.coordinate.longitude
			currentLat = locations.last?.coordinate.latitude
			print("locations = \(currentLong!) \(currentLat!)")
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
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
		locationManager.startUpdatingLocation()
		// Ask for Authorisation from the User.
		isLocationServiceEnabled()
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
	
	@objc func allowTapped() {
		self.locationManager.requestWhenInUseAuthorization()
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
	
	private let allowButton : UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Allow", for: .normal)
		button.backgroundColor = .systemYellow
		button.addTarget(self, action: #selector(allowTapped), for: .touchUpInside)
		button.titleLabel?.font = .boldSystemFont(ofSize: 22)
		button.layer.cornerRadius = 10
		return button
	}()
	
	func createLayout() {
		view.backgroundColor = .white
		view.addSubview(displayText)
		view.addSubview(displayImage)
		view.addSubview(allowButton)
		
		displayImage.snp.makeConstraints { (make) in
			make.width.equalTo(300)
			make.height.equalTo(300)
			make.centerX.equalTo(view.snp.centerX)
			make.top.equalTo(view.snp.top).offset(70)
		}
		
		displayText.snp.makeConstraints { (make) in
			make.width.equalTo(400)
			make.height.equalTo(200)
			make.centerX.equalTo(view.snp.centerX)
			make.top.equalTo(displayImage.snp.bottom).offset(50)
		}
		
		allowButton.snp.makeConstraints { (make) in
			make.width.equalTo(250)
			make.height.equalTo(60)
			make.top.equalTo(displayText.snp.bottom).offset(30)
			make.centerX.equalTo(view.snp.centerX)
		}
	}
}
