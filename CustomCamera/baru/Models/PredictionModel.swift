//
//  PredictionModel.swift
//  CustomCamera
//
//  Created by Heical Chandra on 22/08/24.
//

import Foundation

struct PredictionResponse: Codable {
    let acne_prediction: String
    let acne_level_prediction: String
    let comedo_prediction: String
}
