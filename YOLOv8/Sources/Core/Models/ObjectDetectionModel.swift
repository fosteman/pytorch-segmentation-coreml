//
// Created by moonl1ght 27.02.2023.
//

import Foundation
import CoreML

final class ObjectDetectionModel {
  enum Error: Swift.Error {
    case failedToLoadModel
  }
  static let inputSize = CGSize(width: 2048, height: 2048)
  static let stide: Int = 86016
  static let segmentationMaskLength: Int = 32
  static let segmentationMaskSize = CGSize(width: 512, height: 512)

  static let classes = ["base", "gizzard", "junction", "proventriculus"  ]

  enum ModelType {
    case normal
    case withSegmentation
  }

  enum ModelSize {
    case nano
    case small
    case large
    case xlarge
  }

  final class Output {
    let output: MLMultiArray
    let proto: MLMultiArray?

    init(output: MLMultiArray, proto: MLMultiArray?) {
      self.output = output
      self.proto = proto
    }
  }

  private var modeln: YOLOv8n?
  private var modelns: YOLOv8nseg?
  private var models: YOLOv8s?
  private var modelss: segment_amaranth_grill_2560?
  private var modelType: ModelType = .withSegmentation
  private var modalSize: ModelSize = .small

  func load(modelType: ModelType, modelSize: ModelSize) throws {
    self.modelType = modelType
    self.modalSize = modelSize
    switch modelType {
    case .normal:
      switch modelSize {
      case .nano:
        modeln = try YOLOv8n(configuration: .init())
      case .small:
        models = try YOLOv8s(configuration: .init())
      case .large, .xlarge:
        throw Error.failedToLoadModel
      }
    case .withSegmentation:
      switch modelSize {
      case .nano:
        modelns = try YOLOv8nseg(configuration: .init())
      case .small:
        modelss = try segment_amaranth_grill_2560(configuration: .init())
      case .large, .xlarge:
        throw Error.failedToLoadModel
      }
    }

  }

  func predict(image: CVPixelBuffer) -> Output? {
    do {
      switch modelType {
      case .normal:
        switch modalSize {
        case .nano:
          guard let result = try modeln?.prediction(image: image) else { return nil }
          return Output(output: result.var_914, proto: nil)
        case .small:
          guard let result = try models?.prediction(image: image) else { return nil }
          return Output(output: result.var_914, proto: nil)
        case .large, .xlarge:
          return nil
        }
      case .withSegmentation:
        switch modalSize {
        case .nano:
          guard let result = try modelns?.prediction(image: image) else { return nil }
          return Output(output: result.var_1053, proto: result.p)
        case .small:
          guard let result = try modelss?.prediction(image: image) else { return nil }
          return Output(output: result.var_1052, proto: result.p)
        case .large, .xlarge:
          return nil
        }
      }
    } catch {
      assertionFailure(error.localizedDescription)
      return nil
    }
  }
}
