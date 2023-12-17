//
//  ImageViewWrapper.swift
//  CGGenTest
//
//  Created by Матвей Борисов on 17.12.2023.
//

import SwiftUI
import UIKit

struct ImageViewWrapper: UIViewRepresentable {
	let image: UIImage?

	func makeUIView(context: Context) -> UIImageView {
		let imageView = UIImageMeasureView(frame: .zero)
		imageView.contentMode = .scaleAspectFit
		return imageView
	}

	func updateUIView(_ uiView: UIImageView, context: Context) {
		uiView.image = image
	}
}
