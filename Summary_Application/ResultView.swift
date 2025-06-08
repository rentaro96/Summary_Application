//
//  ResultView.swift
//  Summary_Application
//
//  Created by 鈴木廉太郎 on 2025/06/08.
//

import SwiftUI

struct ResultView: View {
    @ObservedObject var vm: ScanViewModel

    var body: some View {
        NavigationStack {
            List {
                if !vm.summary.isEmpty {
                    Section("要約") {
                        Text(vm.summary)
                    }
                }
                if !vm.extractedText.isEmpty {
                    Section("全文") {
                        Text(vm.extractedText)
                    }
                }
            }
            .navigationTitle("解析結果")
            .toolbar { Button("閉じる") { dismiss() } }
        }
    }

    @Environment(\.dismiss) private var dismiss
}
