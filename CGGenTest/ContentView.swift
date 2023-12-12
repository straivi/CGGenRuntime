//
//  ContentView.swift
//  CGGenTest
//
//  Created by Матвей Борисов on 31.10.2023.
//

import SwiftUI

struct ContentView: View {

	@StateObject private var viewModel = ContentViewModel()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
			Button(action: {
				Task {
					await viewModel.generateImage()
				}

			}, label: {
				Text("Show Image")
					.font(Font.system(size: 20, weight: .bold))
					.frame(height: 50)
					.frame(maxWidth: .infinity)
					.foregroundStyle(Color.white)
					.background(Color(red: 0.27, green: 0.35, blue: 0.96))
					.clipShape(RoundedRectangle(cornerRadius: 14))

			})
            Text("Hello, world!")
			if let image = viewModel.image {
				Image(uiImage: UIImage(cgImage: image))
					.frame(width: 50, height: 50, alignment: .center)
			}
        }
        .padding()
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
