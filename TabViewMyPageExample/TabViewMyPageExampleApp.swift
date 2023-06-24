//
//  TabViewMyPageExampleApp.swift
//  TabViewMyPageExample
//
//  Created by 長内幸太郎 on 2023/06/21.
//

import SwiftUI

class SafeAreaValues: ObservableObject {
    @Published var top: CGFloat = 0
    @Published var bottom: CGFloat = 0
    @Published var left: CGFloat = 0
    @Published var right: CGFloat = 0
}

@main
struct TabViewMyPageExampleApp: App {
    @StateObject var safeAreaValues = SafeAreaValues()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        (UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero).insets
    }
}

extension EnvironmentValues {

    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {

    var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
