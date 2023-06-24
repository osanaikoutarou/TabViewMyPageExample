//
//  ContentView.swift
//  TabViewMyPageExample
//
//  Created by 長内幸太郎 on 2023/06/21.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0

    @State private var scrollOffsetForAlpha: CGFloat = 0
    @State private var scrollOffsetForBeta: CGFloat = 0
    @State private var scrollOffsetForOmega: CGFloat = 0

    @State private var headerTop: CGFloat = 0

    @Environment(\.safeAreaInsets) private var safeAreaInsets

    enum TabViewScreensShowState {
        case unknown
        case p0     // 画面0のみ表示
        case p0and1 // 画面0,1が表示
        case p1
        case p1and2
        case p2
    }

    @State var currentShowingState: TabViewScreensShowState = .p0
    @State var prevShowingState: TabViewScreensShowState = .unknown
    @State var onAppear0: Bool = false
    @State var onAppear1: Bool = false
    @State var onAppear2: Bool = false

    @State var tabViewOffsetX: CGFloat = 0

    var headerHeight: CGFloat { 600 }
    var tabHeight: CGFloat { 35 }
    var barHeight: CGFloat { 5 }
    var scrollableHeight: CGFloat { headerHeight - safeAreaInsets.top - 44 }

    var body: some View {
        NavigationView {
            ZStack {

                VStack {
                    // ヘッダー画像
                    Text("ヘッダー画像エリア")
                }
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.width)
                .background { Color.green }
                .position(x: UIScreen.main.bounds.width/2.0, y: UIScreen.main.bounds.width/2.0)

                TabView(selection: $selection) {
                    alphaView
                        .tag(0)
                        .edgesIgnoringSafeArea(.all)
                    betaView
                        .tag(1)
                        .edgesIgnoringSafeArea(.all)
                    omegaView
                        .tag(2)
                        .edgesIgnoringSafeArea(.all)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .onPreferenceChange(ViewOffsetKey0.self) {
                    // 意図しないタイミングで$0==0が投げられるため、その対応
                    if $0 == 0 {
                        setCurrentShowingStateBySelection()
                        if selection == 0 {
                            tabViewOffsetX = 0
                        }
                    }
                    else {
                        if $0 > UIScreen.main.bounds.width * 0 && $0 < UIScreen.main.bounds.width * 1.0 {
                            currentShowingState = .p0and1
                        }
                        if $0 <= 0 {
                            currentShowingState = .p0
                        }
                        tabViewOffsetX = $0
                    }
                }
                .onPreferenceChange(ViewOffsetKey1.self) {
                    print($0)
                    // 意図しないタイミングで$0==0が投げられるため、その対応
                    if $0 == 0 {
                        setCurrentShowingStateBySelection()
                        if selection == 0 {
                            tabViewOffsetX = 0
                        }
                    }
                    else {
                        if $0 > UIScreen.main.bounds.width * 1.0 && $0 < UIScreen.main.bounds.width * 2.0 {
                            currentShowingState = .p1and2
                        }
                        if $0 == UIScreen.main.bounds.width * 1.0 {
                            currentShowingState = .p1
                        }
                        tabViewOffsetX = $0
                    }
                }
                .onPreferenceChange(ViewOffsetKey2.self) {
                    print($0)
                    // 意図しないタイミングで$0==0が投げられるため、その対応
                    if $0 == 0 {
                        setCurrentShowingStateBySelection()
                        if selection == 0 {
                            tabViewOffsetX = 0
                        }
                    }
                    else {
                        if $0 >= UIScreen.main.bounds.width * 2.0 {
                            currentShowingState = .p2
                        }
                        tabViewOffsetX = $0
                    }
                }
                .onChange(of: currentShowingState) { newValue in
                    onAppear0 = false
                    onAppear1 = false
                    onAppear2 = false

                    if prevShowingState == .unknown && newValue == .p0 {
                        onAppear0 = true
                    }
                    else if prevShowingState == .p0 && newValue == .p0and1 {
                        onAppear1 = true
                    }
                    else if prevShowingState == .p1 && newValue == .p1and2 {
                        onAppear2 = true
                    }
                    else if prevShowingState == .p2 && newValue == .p1and2 {
                        onAppear1 = true
                    }
                    else if prevShowingState == .p1 && newValue == .p0and1 {
                        onAppear0 = true
                    }

                    prevShowingState = newValue
                }

                VStack {
                    // ヘッダー＋タブ
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(spacing: 0) {

                            VStack {
                                // ここはSpacerにする
                                Text("透明エリア")
                            }
                            .frame(width: UIScreen.main.bounds.width,
                                   height: UIScreen.main.bounds.width - 200)
                            .background { Color.blue.opacity(0.2) }

                            Spacer()
                                .frame(height: 200 - 72)

                            HStack {
                                // ここはアイコンなど
                                Text("アイコンエリア")
                            }
                            .frame(width: UIScreen.main.bounds.width, height: 72)
                            .background { Color.red.opacity(0.3) }

                            VStack {
                                Spacer()

                                Text("プロフィールエリア")

                                Spacer()
                            }
                            .frame(width: UIScreen.main.bounds.width)
                            .background { Color.white.opacity(0.4) }

                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: headerHeight)
                        .background { Color.white.opacity(0.5) }
                        .allowsHitTesting(false)

                        // タブ
                        HStack(spacing: 0) {
                            ForEach(0..<3) { index in
                                Button(action: {
                                    self.selection = index

                                    onAppear0 = false
                                    onAppear1 = false
                                    onAppear2 = false
                                    if index == 0 {
                                        onAppear0 = true
                                    }
                                    if index == 1 {
                                        onAppear1 = true
                                    }
                                    if index == 2 {
                                        onAppear2 = true
                                    }
                                }) {
                                    VStack {
                                        Text("Page")
                                    }
                                    .frame(width: UIScreen.main.bounds.width/3.0 ,
                                           height: tabHeight - barHeight)  // タブの高さ
                                    .background { self.selection == index ? Color.orange : Color.gray }
                                }
                            }
                        }

                        // バー
                        VStack {
                        }
                        .frame(width: UIScreen.main.bounds.width/3.0, height: barHeight)
                        .background { Color.black }
                        .offset(x: tabViewOffsetX/3.0)

                    }
                    .offset(y: -headerTop)     // ⭐

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            }
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            .navigationBarTitle("Title", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                print("Button tapped")
            }) {
                Text("Button")
            })
//            .background(LinearGradient(gradient: Gradient(colors: [Color.clear]), startPoint: .top, endPoint: .bottom))
        }
        .onAppear() {
            // 完全に透明に
//            let navigationBarAppearance = UINavigationBarAppearance()
//            navigationBarAppearance.configureWithTransparentBackground()
//            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
//            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
//            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }

    }

    @ViewBuilder
    var alphaView: some View {
        AlphaView(tabViewIndex: 0,
                  headerHeight: headerHeight,
                  tabHeight: tabHeight,
                  scrollableHeight: scrollableHeight,
                  selection: $selection,
                  scrollOffsetForAlpha: $scrollOffsetForAlpha,
                  scrollOffsetForBeta: $scrollOffsetForBeta,
                  scrollOffsetForOmega: $scrollOffsetForOmega,
                  headerTop: $headerTop,
                  customOnAppear: $onAppear0)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background { Color.clear }
            .background(GeometryReader {
                Color.clear.preference(key: ViewOffsetKey0.self,
                                       value: UIScreen.main.bounds.width * 0 - $0.frame(in: .global).minX)
            })
    }
    @ViewBuilder
    var betaView: some View {
        BetaView(tabViewIndex: 1,
                 headerHeight: headerHeight,
                 tabHeight: tabHeight,
                 scrollableHeight: scrollableHeight,
                 selection: $selection,
                 scrollOffsetForAlpha: $scrollOffsetForAlpha,
                 scrollOffsetForBeta: $scrollOffsetForBeta,
                 scrollOffsetForOmega: $scrollOffsetForOmega,
                 headerTop: $headerTop,
                 customOnAppear: $onAppear1)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background { Color.green }
            .background(GeometryReader {
                Color.clear.preference(key: ViewOffsetKey1.self,
                                       value: UIScreen.main.bounds.width * 1.0 - $0.frame(in: .global).minX)
            })
    }
    @ViewBuilder
    var omegaView: some View {
        OmegaView(tabViewIndex: 2,
                  headerHeight: headerHeight,
                  tabHeight: tabHeight,
                  scrollableHeight: scrollableHeight,
                  selection: $selection,
                  scrollOffsetForAlpha: $scrollOffsetForAlpha,
                  scrollOffsetForBeta: $scrollOffsetForBeta,
                  scrollOffsetForOmega: $scrollOffsetForOmega,
                  headerTop: $headerTop,
                  customOnAppear: $onAppear2)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background { Color.blue }
            .background(GeometryReader {
                Color.clear.preference(key: ViewOffsetKey2.self,
                                       value: UIScreen.main.bounds.width * 2.0 - $0.frame(in: .global).minX)
            })
    }

    func setCurrentShowingStateBySelection() {
        if selection == 0 {
            currentShowingState = .p0
        }
        if selection == 1 {
            currentShowingState = .p1
        }
        if selection == 2 {
            currentShowingState = .p2
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



// PreferenceKeys
struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        let next = nextValue()
        value += next
    }
}
struct ViewOffsetKey0: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
struct ViewOffsetKey1: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
struct ViewOffsetKey2: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

var thin: CGFloat { 0.1 }

//実際には不要
struct Model: Identifiable {
    var id: String = UUID().uuidString
    var title: String
}
