//
//  Scan.swift
//  Summary_Application
//
//  Created by 鈴木廉太郎 on 2025/05/25.
//

import SwiftUI


struct Scan: View {
    @StateObject private var vm = ScanViewModel()
    @State private var showScanner = false

    var body: some View {
        NavigationStack {
            content                       // ← 中身だけあとで定義
                .navigationTitle("スキャン")

                // ★ NavigationStack 内側に 1 回だけ
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button("スキャン") { showScanner = true }
                        if !vm.pages.isEmpty {
                            Button("リセット", role: .destructive) { vm.reset() }
                        }
                    }
                }
        }
        // スキャナーは外側で OK
        .sheet(isPresented: $showScanner) {
            DocumentScannerView { result in
                if case let .success(images) = result {
                    vm.pages = images          // ここで pages を更新
                }
            }
        }
    }

    // --- 中身だけ切り出してスッキリ ---
    @ViewBuilder
    private var content: some View {
        if vm.pages.isEmpty {
            ContentUnavailableView("スキャンされたページはありません",
                                   systemImage: "doc.on.clipboard")
                .frame(maxHeight: .infinity)          // ← 下に押し広げてツールバーと干渉させない
        } else {
            VStack(spacing: 16) {
                TabView {
                    ForEach(vm.pages.indices, id: \.self) { idx in
                        Image(uiImage: vm.pages[idx])
                            .resizable()
                            .scaledToFit()
                    }
                }
                .tabViewStyle(.page)
                .frame(maxHeight: .infinity)

                Button("解析を開始") { vm.analyze() }
                    .disabled(vm.pages.isEmpty || vm.isBusy)
                    .buttonStyle(.borderedProminent)
                    .overlay {
                        if vm.isBusy { ProgressView().progressViewStyle(.circular) }
                    }
                    .onChange(of: vm.summary) { _ in
                        if !vm.summary.isEmpty { showResult = true }
                    }
                    .sheet(isPresented: $showResult) {
                        ResultView(vm: vm)
                    }
            }
            .padding(.bottom, 8)                      // ページドットとツールバーの間隔を少し確保
        }
    }
}

#Preview { Scan() }
