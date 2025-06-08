//
//  ScanViewModel.swift
//  Summary_Application
//
//  Created by 鈴木廉太郎 on 2025/06/08.
//

import SwiftUI
import PDFKit

@MainActor
final class ScanViewModel: ObservableObject {
    @Published var pages: [UIImage] = []
    @Published var pdfURL: URL?

    /// 取得した画像配列から一時 PDF を生成
    func buildPDF() throws {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("pdf")

        guard let consumer = CGDataConsumer(url: url as CFURL) else { throw CocoaError(.fileWriteUnknown) }
        var mediaBox = CGRect(origin: .zero, size: pages.first!.size)
        guard let ctx = CGContext(consumer: consumer, mediaBox: &mediaBox, nil) else { throw CocoaError(.fileWriteUnknown) }
        for img in pages {
            ctx.beginPDFPage(nil)
            ctx.draw(img.cgImage!, in: mediaBox)
            ctx.endPDFPage()
        }
        ctx.closePDF()
        pdfURL = url
    }

    func reset() { pages.removeAll(); pdfURL = nil }
}
