//
//  ScanViewModel.swift
//  Summary_Application
//
//  Created by 鈴木廉太郎 on 2025/06/08.
//

import SwiftUI

@MainActor
final class ScanViewModel: ObservableObject {
    @Published var pages: [UIImage] = []
    @Published var extractedText: String = ""
    @Published var summary: String = ""
    @Published var isBusy = false
    @Published var error: String?

    /// 「解析を開始」ボタンが押されたら呼ぶ
    func analyze() {
        isBusy = true
        error = nil

        Task {
            do {
                // 1️⃣ OCR
                let texts = try await pages.asyncMap {
                    try await TextRecognitionService.recognize(in: $0)
                }
                extractedText = texts.joined(separator: "\n\n")

                // 2️⃣ 要約
                summary = SummarizationService.summarize(extractedText)

            } catch {
                self.error = error.localizedDescription
            }
            isBusy = false
        }
    }

    func reset() {
        pages.removeAll()
        extractedText = ""
        summary = ""
    }
}

// 配列を並列で回す簡単ユーティリティ
extension Array {
    func asyncMap<T>(_ transform: (Element) async throws -> T) async rethrows -> [T] {
        try await withThrowingTaskGroup(of: (Int, T).self) { group in
            for (i, element) in enumerated() {
                group.addTask { (i, try await transform(element)) }
            }
            return try await group.reduce(into: Array<T?>(repeating: nil, count: count)) { acc, next in
                acc[next.0] = next.1
            }.compactMap { $0 }
        }
    }
}
