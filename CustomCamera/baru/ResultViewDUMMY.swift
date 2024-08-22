//
//  ResultViewDUMMY.swift
//  CustomCamera
//
//  Created by Heical Chandra on 21/08/24.
//

import SwiftUI

struct ResultViewDUMMY: View {
//    @ObservedObject var imageClassifier: ImageClassifier
    @StateObject private var classifier = ImageClassifier()
    @State var selectedImage: UIImage?

    var body: some View {
        VStack {
            Image(uiImage: selectedImage!)
                .resizable()
                .frame(width: UIScreen.main.bounds.width - 45, height: 320)
                .cornerRadius(16)
                .scaledToFit()
            Text("Acne Prediction: \(classifier.acnePrediction)")
                .font(.title)
                .padding()
            Text("Acne Level Prediction: \(classifier.acneLevelPrediction)")
                .font(.title)
                .padding()
            Text("Comedo Prediction: \(classifier.comedoPrediction)")
                .font(.title)
                .padding()

            Spacer()
        }
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let image = selectedImage {
                classifier.classifyImage(image: image)
            }
        }
    }
}

//
//#Preview {
//    ResultViewDUMMY()
//}
