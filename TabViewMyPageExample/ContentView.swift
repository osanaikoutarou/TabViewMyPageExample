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

    @State private var headerTop: CGFloat = 200

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

    var headerHeight: CGFloat { 300 }
    var tabHeight: CGFloat { 30 }
    var scrollableHeight: CGFloat { 250 }

    var body: some View {
        ZStack {
            TabView(selection: $selection) {
                alphaView.tag(0)
                betaView.tag(1)
                omegaView.tag(2)
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
                    HStack {
                        // ヘッダーはここ
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .background(.white.opacity(0.5))
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
                                       height: tabHeight)  // タブの高さ
                                .background(self.selection == index ? Color.orange : Color.gray)
                            }
                        }
                    }
                    .edgesIgnoringSafeArea(.all)

                    // バー
                    VStack {
                    }
                    .frame(width: UIScreen.main.bounds.width/3.0, height: 5)
                    .background(.black)
                    .offset(x: tabViewOffsetX/3.0)
                    .edgesIgnoringSafeArea(.all)

                }
                .offset(y: -headerTop)     // ⭐

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
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
            .background(Color.red)
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
            .background(Color.green)
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
            .background(Color.blue)
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
