//
//  Extensions.swift
//  weather
//
//  Created by Will on 9/14/20.
//  Copyright © 2020 Will. All rights reserved.
//

import Foundation
import UIKit

let rainArray : [Int] = [1,2,3,4,5,6,7,8,9,10]
let cloudyArray : [Int] = [26,27,28,29,30]
let snowArray : [Int] = [13,14,15,16]
let sunnyArray : [Int] = [31,32,33,34]
let stormArray : [Int] = [41,42,43,44,45,46,47]

public extension UIViewController{
    func showLoading() {
        let loadingView = UIView()
        let loadingIndicator = UIActivityIndicatorView()
        
        loadingView.backgroundColor = .black
        loadingView.alpha = 0.8
        loadingView.frame = self.view.bounds
        loadingView.tag = 1338
        loadingIndicator.tag = 1339
			loadingIndicator.style = UIActivityIndicatorView.Style.large
        self.view.addSubview(loadingView)
        self.view.addSubview(loadingIndicator)
        
        loadingIndicator.startAnimating()
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: loadingIndicator, attribute: .centerX, relatedBy: .equal, toItem: loadingView, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: loadingIndicator, attribute: .centerY, relatedBy: .equal, toItem: loadingView, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
    }
    
    func removeLoading() {
        DispatchQueue.main.async {
            if let viewWithTag = self.view.viewWithTag(1338) {
                viewWithTag.removeFromSuperview()
            }
            if let viewWithTag2 = self.view.viewWithTag(1339) {
                viewWithTag2.removeFromSuperview()
            }
        }
    }
	
	func presentToRight(vc: UIViewController){
		let vc = vc
		vc.modalPresentationStyle = .fullScreen
		let transition = CATransition()
		transition.duration = 0.5
		transition.type = CATransitionType.push
		transition.subtype = CATransitionSubtype.fromRight
		transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
		view.window!.layer.add(transition, forKey: kCATransition)
		present(vc, animated: false, completion: nil)
	}
	
	func presentToLeft(vc: UIViewController){
		let vc = vc
		vc.modalPresentationStyle = .fullScreen
		let transition = CATransition()
		transition.duration = 0.5
		transition.type = CATransitionType.push
		transition.subtype = CATransitionSubtype.fromLeft
		transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
		view.window!.layer.add(transition, forKey: kCATransition)
		present(vc, animated: false, completion: nil)
	}
}
