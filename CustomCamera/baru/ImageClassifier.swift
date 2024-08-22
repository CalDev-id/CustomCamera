//
//  ImageClassifier.swift
//  CustomCamera
//
//  Created by Heical Chandra on 21/08/24.
//

import SwiftUI

class ImageClassifier: ObservableObject {
    @Published var acnePrediction: String = ""
    @Published var acneLevelPrediction: String = ""
    @Published var comedoPrediction: String = ""
    @Published var isResult: Bool = false

    func classifyImage(image: UIImage) {
        guard let compressedImage = compressImage(image) else {
            print("Failed to compress image")
            return
        }

        guard let url = URL(string: "https://wooden-ardeen-skinalyze-50b5c1a0.koyeb.app/Skinalyze-Predict/") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")

        let boundary = UUID().uuidString
        let boundaryPrefix = "--\(boundary)\r\n"
        let boundarySuffix = "\r\n--\(boundary)--\r\n"

        var body = Data()
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n")
        body.appendString("Content-Type: image/jpeg\r\n\r\n")
        body.append(compressedImage)
        body.appendString(boundarySuffix)

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response from server")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            // Debugging: Print the raw JSON response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response: \(jsonString)")
            }

            guard let predictionResponse = try? JSONDecoder().decode(PredictionResponse.self, from: data) else {
                print("Failed to decode JSON response")
                return
            }

            DispatchQueue.main.async {
                self.acnePrediction = predictionResponse.acne_prediction
                self.acneLevelPrediction = predictionResponse.acne_level_prediction
                self.comedoPrediction = predictionResponse.comedo_prediction
                self.isResult = true
            }
        }

        task.resume()
    }

    private func compressImage(_ image: UIImage) -> Data? {
        return image.jpegData(compressionQuality: 0.5)
    }
}

extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
