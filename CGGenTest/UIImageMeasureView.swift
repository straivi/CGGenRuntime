//
//  UIImageMeasureView.swift
//  CGGenTest
//
//  Created by Матвей Борисов on 17.12.2023.
//

import Foundation
import UIKit

class UIImageMeasureView: UIImageView {

	private let clock = ContinuousClock()
	
	override func layoutSubviews() {
		let time = clock.measure {
			super.layoutSubviews()
		}
		print("layoutSubviews: \(time)")
	}
}
