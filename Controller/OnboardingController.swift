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
	
	private func determineLocationPermissions() {
		locationManager.delegate = self
		if CLLocationManager.locationServicesEnabled() {
			switch CLLocationManager.authorizationStatus() {
			case .notDetermined:
				locationManager.requestWhenInUseAuthorization()
			case .authorizedWhenInUse:
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
    override func viewDidLoad() {
        super.viewDidLoad()
				view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        // Do any additional setup after loading the view.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		determineLocationPermissions()
	}

}
