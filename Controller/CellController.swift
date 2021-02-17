//
//  CellController.swift
//  weather
//
//  Created by Will on 10/17/20.
//  Copyright © 2020 Will. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

extension CurrentWeatherController: UICollectionViewDataSource {
	
	public func collectionView(_ collectionView: UICollectionView,
											numberOfItemsInSection section: Int) -> Int {
		return Forecast.count
	}
	
	public func collectionView(_ collectionView: UICollectionView,
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
		cell.tempLabel.text = "\(Int(data.high))° | \(Int(data.low))°"
		updateIconImage(weatherCode: Double(data.code), imageView: cell.weatherIcon)
		
		cell.backgroundColor = cellBackgroundColor.withAlphaComponent(0.3)
		cell.layer.cornerRadius = 10
		return cell
	}
}

extension CurrentWeatherController: UICollectionViewDelegate {
	
	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
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
		textLabel.textColor = textColor
		self.contentView.addSubview(textLabel)
		
		let tempLabel = UILabel(frame: .zero)
		tempLabel.textColor = textColor
		self.contentView.addSubview(tempLabel)
		
		let weatherIcon = UIImageView(frame: .zero)
		self.contentView.addSubview(weatherIcon)
		
		textLabel.snp.makeConstraints { (make) in
			make.centerX.equalTo(contentView.snp.centerX)
			make.bottom.equalTo(weatherIcon.snp.topMargin).offset(-30)
			make.width.equalTo(110)
		}
		tempLabel.snp.makeConstraints { (make) in
			make.centerX.equalTo(contentView.snp.centerX)
			make.top.equalTo(weatherIcon.snp.bottomMargin).offset(30)
			make.width.equalTo(150)
		}
		weatherIcon.snp.makeConstraints { (make) in
			make.width.equalTo(80)
			make.height.equalTo(80)
			make.centerY.equalTo(contentView.snp.centerY)
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
		self.textLabel.textAlignment = .center
		self.tempLabel.textAlignment = .center
		
		self.textLabel.font = .systemFont(ofSize: 22, weight: .semibold)
		self.tempLabel.font = .systemFont(ofSize: 22, weight: .bold)
	}
}
