//
//  SearchCityController.swift
//  weather
//
//  Created by Will on 10/24/20.
//  Copyright © 2020 Will. All rights reserved.
//

import UIKit
import SnapKit
import CoreLocation
import NotificationBannerSwift

class SearchCityController: UIViewController {

	var Forecast : [Forecast] = []
	
    override func viewDidLoad() {
			super.viewDidLoad()
			view.backgroundColor = .clear
			addBlurredBackground(style: UIBlurEffect.Style.light)
			addSubviews()
			layoutSubviews()
			configureSwipeDirections()
    }
	
	// Inits swipe direction and action
	func configureSwipeDirections() {
		let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
		swipeUp.direction = .down
		self.view.addGestureRecognizer(swipeUp)
	}
	
	@objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
		if let swipeGesture = gesture as? UISwipeGestureRecognizer {
			switch swipeGesture.direction {
			case UISwipeGestureRecognizer.Direction.down:
				self.dismiss(animated: true, completion: nil)
			default:
				break
			}
		}
	}
	
	private let searchBar : UITextField = {
		let search = UITextField()
		search.backgroundColor = .white
		search.font = .systemFont(ofSize: 22, weight: .semibold)
		search.placeholder = "Honolulu, HI"
		search.layer.cornerRadius = 10
		search.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: search.frame.height))
		search.leftViewMode = .always
		search.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
		search.layer.borderWidth = 2
		return search
	}()
	
	private let searchButton : UIButton = {
		let button = UIButton()
		button.backgroundColor = .systemBlue
		button.tintColor = .white
		button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
		button.setTitle("Search", for: .normal)
		button.layer.cornerRadius = 10
		return button
	}()
	
	@objc func searchButtonTapped() {
		let location = searchBar.text!
		print(location)
		getWeatherForLocation(Location: location)
  }
	
	func addBlurredBackground(style: UIBlurEffect.Style) {
		let blurEffect = UIBlurEffect(style: .extraLight)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = self.view.frame
		self.view.insertSubview(blurEffectView, at: 0)
	}
	
	func getWeatherForLocation(Location : String){
		YahooWeatherAPI.shared.weather(location: Location, failure: { (error) in
			print(error.localizedDescription)
		}, success: { (response) in
			let data = response.data
			do {
				let forecast = try JSONDecoder().decode(Weather.self, from: data)
				print(forecast.currentObservation.condition.temperature)
				CurrentWeatherController.shared.createViewWithData(
					location: forecast.location.city,
					summary: forecast.currentObservation.condition.text,
					temperature: forecast.currentObservation.condition.temperature,
					wind: forecast.currentObservation.wind.speed,
					humidity: forecast.currentObservation.atmosphere.humidity,
					sunrise: forecast.currentObservation.astronomy.sunrise,
					sunset: forecast.currentObservation.astronomy.sunset)
				self.dismiss(animated: true, completion: nil)
			} catch {
				print(error)
			}
		}, responseFormat: .json, unit: .imperial)
	}
	
	func addSubviews(){
		view.addSubview(searchBar)
		view.addSubview(searchButton)
	}
	
	func layoutSubviews(){
		searchBar.snp.makeConstraints { (make) in
			make.top.equalTo(view.snp.top).offset(300)
			make.centerX.equalTo(view.snp.centerX)
			make.width.equalTo(300)
			make.height.equalTo(40)
		}
		searchButton.snp.makeConstraints { (make) in
			make.centerX.equalTo(view.snp.centerX)
			make.width.equalTo(100)
			make.height.equalTo(40)
			make.top.equalTo(searchBar.snp.bottom).offset(10)
		}
	}
}
