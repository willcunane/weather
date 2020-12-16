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
	
	public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if (CLLocationManager.locationServicesEnabled()) {
			let vc = CurrentWeatherController()
			vc.modalPresentationStyle = .overFullScreen
			self.present(vc, animated: true, completion: nil)
		} else {
			createAlert(title: "Location Permissions Disabled", message: "You have disabled location permissions for this app. You will only be able to search for locations. To fix this please visit your devices privacy settings for this application", style: .alert)
			let vc = SearchCityController()
			self.present(vc, animated: true, completion: nil)
		}
	}
	
	private func determineLocationPermissions() {
		print(CLLocationManager.authorizationStatus())
		locationManager.delegate = self
		if CLLocationManager.locationServicesEnabled() {
			switch CLLocationManager.authorizationStatus() {
			case .notDetermined:
				locationManager.requestWhenInUseAuthorization()
				print("Location permissions not determined")
			case .authorizedWhenInUse:
				print("Location services allowed")
				let vc = CurrentWeatherController()
				vc.modalPresentationStyle = .overFullScreen
				self.present(vc, animated: true, completion: nil)
			case .restricted:
				createAlert(title: "Location Permissions Disabled", message: "You have disabled location permissions for this app. You will only be able to search for locations. To fix this please visit your devices privacy settings for this application", style: .alert)
				let vc = SearchCityController()
				self.present(vc, animated: true, completion: nil)
			default:
				print("Location permissions not determined")
			}
		}
	}

	private func createAlert(title: String, message: String, style: UIAlertController.Style) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
		alertController.addAction(UIAlertAction(title: "I Understand", style: .destructive))
		self.present(alertController, animated: true, completion: nil)
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
	
	private func createView() {
		view.addSubview(label)
		
		label.snp.makeConstraints { (make) in
			make.width.equalTo(view.snp.width)
			make.centerX.equalTo(view.snp.centerX)
			make.top.equalTo(view.snp.topMargin).offset(80)
		}
	}
    override func viewDidLoad() {
        super.viewDidLoad()
				view.backgroundColor = .systemBlue
			createView()
        // Do any additional setup after loading the view.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		determineLocationPermissions()
	}

}
