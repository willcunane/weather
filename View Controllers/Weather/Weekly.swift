//
//  Weekly.swift
//  weather
//
//  Created by Will on 7/28/20.
//  Copyright © 2020 Will. All rights reserved.
//

import Foundation
import SnapKit

class WeeklyWeatherController: UIViewController {

	 weak var collectionView: UICollectionView!

			var data: [Int] = Array(0..<10)

			override func loadView() {
					super.loadView()

					let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
					collectionView.translatesAutoresizingMaskIntoConstraints = false
					self.view.addSubview(collectionView)
					NSLayoutConstraint.activate([
							self.view.topAnchor.constraint(equalTo: collectionView.topAnchor),
							self.view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
							self.view.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
							self.view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
					])
					self.collectionView = collectionView
			}

			override func viewDidLoad() {
					super.viewDidLoad()

					self.collectionView.dataSource = self
					self.collectionView.delegate = self
					self.collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
					self.collectionView.alwaysBounceVertical = true
					self.collectionView.backgroundColor = .white
			}
	}

	extension WeeklyWeatherController: UICollectionViewDataSource {

			func collectionView(_ collectionView: UICollectionView,
													numberOfItemsInSection section: Int) -> Int {
					return self.data.count
			}

			func collectionView(_ collectionView: UICollectionView,
													cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
					let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as! Cell
					let data = self.data[indexPath.item]
					cell.textLabel.text = String(data)
					return cell
			}
	}

	extension WeeklyWeatherController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 44)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) //.zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

	extension WeeklyWeatherController: UICollectionViewDelegate {

			func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

			}


}

class Cell: UICollectionViewCell {

    static var identifier: String = "Cell"

    weak var textLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        let textLabel = UILabel(frame: .zero)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(textLabel)
        NSLayoutConstraint.activate([
            self.contentView.centerXAnchor.constraint(equalTo: textLabel.centerXAnchor),
            self.contentView.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor),
        ])
        self.textLabel = textLabel
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
    }
}
