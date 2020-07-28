//
//  TabBarController.swift
//  weather
//
//  Created by Will on 7/28/20.
//  Copyright © 2020 Will. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
	
	let rainArray : [Int] = [1,2,3,4,5,6,7,8,9,10]
	let cloudyArray : [Int] = [26,27,28,29,30]
	let snowArray : [Int] = [13,14,15,16]
	let sunnyArray : [Int] = [31,32,33,34]
	let stormArray : [Int] = [41,42,43,44,45,46,47]

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		let vc1 = CurrentWeatherController()
		let vc2 = WeeklyWeatherController()
		viewControllers = [vc1, vc2]
	}


}
