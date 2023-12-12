//
//  ContentViewModel.swift
//  CGGenTest
//
//  Created by Матвей Борисов on 23.11.2023.
//

import Foundation
import libcggen
import BCRunner
import UIKit
import Base

enum RequestError: Swift.Error {
	case invalidURL
	case missingData
}

class ContentViewModel: ObservableObject {

	@Published var image: CGImage?

	@MainActor
	func generateImage() async {
		image = try! await generateImageOutput()
	}

	func generateImageOutput() async throws -> CGImage {
		let clock = ContinuousClock()

		guard let url = Bundle.main.url(forResource: "shapes", withExtension: "svg") else { throw RequestError.invalidURL }
		let data = try Data(contentsOf: url)
		let svg = try SVGParser.root(from: data)

		let parseResult = try clock.measure {
			let _ = try SVGParser.root(from: data)
		}
		print("Parse Data to SVG.Document measure: \(parseResult)")

		let routines: Routines = try SVGToDrawRouteConverter.convert(document: svg)

		let routinesResult = try clock.measure {
			let _: Routines = try SVGToDrawRouteConverter.convert(document: svg)
		}
		print("Parse SVG.Document to SVG.Routines measure: \(routinesResult)")

		let routeBytecode = generateRouteBytecode(route: routines.drawRoutine)

		let bytecodeResult = clock.measure {
			let _ = generateRouteBytecode(route: routines.drawRoutine)
		}
		print("Bytecode generation measure: \(bytecodeResult)")

		let cs = CGColorSpaceCreateDeviceRGB()
		guard let context = CGContext(
			data: nil,
			width: 50,
			height: 50,
			bitsPerComponent: 8,
			bytesPerRow: 0,
			space: cs,
			bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
		) else { fatalError() }

		let cgcontextCreateResult = clock.measure {
			let csMeasure = CGColorSpaceCreateDeviceRGB()
			guard let _ = CGContext(
				data: nil,
				width: 50,
				height: 50,
				bitsPerComponent: 8,
				bytesPerRow: 0,
				space: csMeasure,
				bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
			) else { fatalError() }
		}
		print("cgcontext create measure: \(cgcontextCreateResult)")

		let runBytecodeResult = try clock.measure {
			try runBytecode(context, fromData: Data(routeBytecode))
		}
		print("run bytecode measure: \(runBytecodeResult)")

		let imageCreateResult = clock.measure {
			context.makeImage()
		}
		print("image create measure: \(imageCreateResult)")

		let assetsImageResult = clock.measure {
			let _ = UIImage(named: "shapes")
		}
		print("image from assets measure: \(assetsImageResult)")

		let resultSVGTime = parseResult + routinesResult + bytecodeResult + cgcontextCreateResult + runBytecodeResult + imageCreateResult
		print("result SVG to CGImage conversion measure: \(resultSVGTime)")

		return context.makeImage()!
	}
}
