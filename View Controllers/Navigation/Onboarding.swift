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
	
	let locationManager = CLLocationManager()
	
	override func viewDidLoad(){
		super.viewDidLoad()
		createLayout()
	}
	
	@objc func allowTapped() {
		print("Tapped")
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
