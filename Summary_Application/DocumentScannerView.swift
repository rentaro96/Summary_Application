//
//  DocumentScannerView.swift
//  Summary_Application
//
//  Created by 鈴木廉太郎 on 2025/06/08.
//

import SwiftUI
import VisionKit

struct DocumentScannerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentation
    var onComplete: (Result<[UIImage], Error>) -> Void

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let controller = VNDocumentCameraViewController()
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_: VNDocumentCameraViewController, context _: Context) {}

    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let parent: DocumentScannerView
        init(_ parent: DocumentScannerView) { self.parent = parent }

        func documentCameraViewController(
            _ controller: VNDocumentCameraViewController,
            didFinishWith scan: VNDocumentCameraScan
        ) {
            var pages: [UIImage] = []
            for i in 0..<scan.pageCount { pages.append(scan.imageOfPage(at: i)) }
            parent.onComplete(.success(pages))
            parent.presentation.wrappedValue.dismiss()
        }

        func documentCameraViewControllerDidCancel(_: VNDocumentCameraViewController) {
            parent.presentation.wrappedValue.dismiss()
        }

        func documentCameraViewController(_: VNDocumentCameraViewController, didFailWithError error: Error) {
            parent.onComplete(.failure(error))
            parent.presentation.wrappedValue.dismiss()
        }
    }
}

