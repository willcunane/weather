//
//  Current.swift
//  weather
//
//  Created by Will on 7/28/20.
//  Copyright © 2020 Will. All rights reserved.
//

import Foundation
import SnapKit

class CurrentWeatherController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		view.backgroundColor = .systemBlue
		createLayout()
		setupLayout()
	}
	
	private let currentWeatherImage : UIImageView = {
		let image = #imageLiteral(resourceName: "iconfinder_Weather_669958")
		let imageView = UIImageView.init(image: image)
		return imageView
	}()
	
	private let currentTemperatureLabel : UILabel = {
		let label = UILabel()
		label.text = "°F"
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 50, weight: .bold)
		label.textColor = .white
		return label
	}()
	
	func createLayout() {
		view.addSubview(currentWeatherImage)
		view.addSubview(currentTemperatureLabel)
	}
	
	func setupLayout() {
		currentWeatherImage.snp.makeConstraints { (make) in
			make.width.equalTo(250)
			make.height.equalTo(250)
			make.top.equalTo(50)
			make.centerX.equalTo(view.snp.centerX)
		}
		currentTemperatureLabel.snp.makeConstraints { (make) in
			make.width.equalTo(120)
			make.height.equalTo(70)
			make.top.equalTo(currentWeatherImage.snp.bottom).offset(10)
			make.centerX.equalTo(view.snp.centerX)
		}
	}

}
