//
//  Menubar.swift
//  Summary_Application
//
//  Created by 鈴木廉太郎 on 2025/05/25.
//

import SwiftUI

struct Menubar: View {
    var body: some View {
        TabView {
            history()
                .tabItem{
                    Image(systemName:"clock.fill")
                    Text("履歴")
                }
            Help()
                .tabItem{
                    Image(systemName: "questionmark")
                    Text("使い方")
                }
            Scan()
                .tabItem{
                    Image(systemName: "camera.fill")
                    Text("カメラ")
                }
        }
    }
}


#Preview {
    Menubar()
}
