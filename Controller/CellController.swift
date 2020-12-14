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
		return cell
	}
}

extension CurrentWeatherController: UICollectionViewDelegate {
	
	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
	}
}

extension CurrentWeatherController: UICollectionViewDelegateFlowLayout {
	
	public func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.bounds.width, height: 70)
	}
	
	public func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) //.zero
	}
	
	public func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	public func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
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
		textLabel.textColor = .white
		self.contentView.addSubview(textLabel)
		
		let tempLabel = UILabel(frame: .zero)
		tempLabel.textColor = .white
		self.contentView.addSubview(tempLabel)
		
		let weatherIcon = UIImageView(frame: .zero)
		self.contentView.addSubview(weatherIcon)
		
		textLabel.snp.makeConstraints { (make) in
			make.leading.equalTo(20)
			make.centerY.equalTo(self.snp.centerY)
			make.width.equalTo(110)
		}
		tempLabel.snp.makeConstraints { (make) in
			make.trailing.equalTo(-20)
			make.centerY.equalTo(self.snp.centerY)
			make.width.equalTo(80)
		}
		weatherIcon.snp.makeConstraints { (make) in
			make.width.equalTo(50)
			make.height.equalTo(50)
			make.centerY.equalTo(self.snp.centerY)
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
		self.textLabel.textAlignment = .left
		self.tempLabel.textAlignment = .left
		
		self.textLabel.font = .systemFont(ofSize: 18, weight: .regular)
		self.tempLabel.font = .systemFont(ofSize: 18, weight: .bold)
	}
}
