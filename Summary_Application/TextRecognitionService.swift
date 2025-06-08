//
//  TextRecognitionService.swift
//  Summary_Application
//
//  Created by 鈴木廉太郎 on 2025/06/08.
//

import Vision
import UIKit

final class TextRecognitionService {
    /// 画像から文字列を取って返す（非同期）
    static func recognize(in image: UIImage) async throws -> String {
        // iOS 17 以降なら直接 `VNImageRequestHandler` に UIImage を渡せる
        let cgImage = try image.cgImage
            ?? XCTUnwrapError()   // 自前エラー or Extension で用意してね
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        let handler = VNImageRequestHandler(cgImage: cgImage)
        try handler.perform([request])

        let texts = request.results?
            .compactMap { $0.topCandidates(1).first?.string }
            .joined(separator: "\n") ?? ""

        return texts
    }
}
