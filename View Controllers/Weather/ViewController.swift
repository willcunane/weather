//
//  ViewController.swift
//  weather
//
//  Created by Will on 10/11/20.
//  Copyright © 2020 Will. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
			super.viewDidLoad()
			view.backgroundColor = .systemBlue
			createSwipeDirections()
    }
	
	func createSwipeDirections(){
		let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
		swipeRight.direction = UISwipeGestureRecognizer.Direction.right
    self.view.addGestureRecognizer(swipeRight)
		
		let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
		swipeRight.direction = UISwipeGestureRecognizer.Direction.left
    self.view.addGestureRecognizer(swipeLeft)
	}
	
	@objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
			if let swipeGesture = gesture as? UISwipeGestureRecognizer {
					switch swipeGesture.direction {
					case UISwipeGestureRecognizer.Direction.right:
						presentToLeft(vc: CurrentWeatherController())
					default:
							break
					}
			}
	}
	
	func createConstraints(){
	}

}
