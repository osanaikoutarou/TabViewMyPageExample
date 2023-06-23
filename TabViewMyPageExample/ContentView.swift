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

    @State private var paddingTop: CGFloat = 200
//    @State private var paddingTopForAlpha: CGFloat = 200
//    @State private var paddingTopForBeta: CGFloat = 200
//    @State private var paddingTopForOmega: CGFloat = 200

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

    var scrollOffset: CGFloat {
        scrollOffsetForAlpha
    }

    var body: some View {

        ZStack {
            TabView(selection: $selection) {
                AlphaView(scrollOffsetForAlpha: $scrollOffsetForAlpha,
                          scrollOffsetForBeta: $scrollOffsetForBeta,
                          scrollOffsetForOmega: $scrollOffsetForOmega,
                          paddingTop: $paddingTop,
                          selection: $selection,
                          customOnAppear: $onAppear0)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.red)
                    .background(GeometryReader {
                        // read and store origin (min X) of page
                        Color.clear.preference(key: ViewOffsetKey0.self,
                                               value: UIScreen.main.bounds.width * 0 - $0.frame(in: .global).minX)
                    })
                    .tag(0)
                BetaView(scrollOffsetForAlpha: $scrollOffsetForAlpha,
                         scrollOffsetForBeta: $scrollOffsetForBeta,
                         scrollOffsetForOmega: $scrollOffsetForOmega,
                         paddingTop: $paddingTop,
                         selection: $selection,
                         customOnAppear: $onAppear1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.green)
                    .background(GeometryReader {
                        // read and store origin (min X) of page
                        Color.clear.preference(key: ViewOffsetKey1.self,
                                               value: UIScreen.main.bounds.width * 1.0 - $0.frame(in: .global).minX)
                    })
                    .tag(1)
                OmegaView(scrollOffsetForAlpha: $scrollOffsetForAlpha,
                          scrollOffsetForBeta: $scrollOffsetForBeta,
                          scrollOffsetForOmega: $scrollOffsetForOmega,
                          paddingTop: $paddingTop,
                          selection: $selection,
                          customOnAppear: $onAppear2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.blue)
                    .background(GeometryReader {
                        // read and store origin (min X) of page
                        Color.clear.preference(key: ViewOffsetKey2.self,
                                               value: UIScreen.main.bounds.width * 2.0 - $0.frame(in: .global).minX)
                    })
                    .tag(2)
                    .onAppear {
                        print("🐙", "Omega3")
                    }

            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onPreferenceChange(ViewOffsetKey0.self) {
                // 意図しないタイミングで$0==0が投げられるため、その対応
                if $0 == 0 {
                    setCurrentShowingStateBySelection()
                }
                else {
                    if $0 > UIScreen.main.bounds.width * 0 && $0 < UIScreen.main.bounds.width * 1.0 {
                        currentShowingState = .p0and1
                    }
                    if $0 <= 0 {
                        currentShowingState = .p0
                    }
                }
            }
            .onPreferenceChange(ViewOffsetKey1.self) {
                // 意図しないタイミングで$0==0が投げられるため、その対応
                if $0 == 0 {
                    setCurrentShowingStateBySelection()
                }
                else {
                    if $0 > UIScreen.main.bounds.width * 1.0 && $0 < UIScreen.main.bounds.width * 2.0 {
                        currentShowingState = .p1and2
                    }
                    if $0 == UIScreen.main.bounds.width * 1.0 {
                        currentShowingState = .p1
                    }
                }
            }
            .onPreferenceChange(ViewOffsetKey2.self) {
                // 意図しないタイミングで$0==0が投げられるため、その対応
                if $0 == 0 {
                    setCurrentShowingStateBySelection()
                }
                else {
                    if $0 >= UIScreen.main.bounds.width * 2.0 {
                        currentShowingState = .p2
                    }
                }
            }
            .onChange(of: currentShowingState) { newValue in
                print("⭐", newValue)
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




            // これがヘッダー部分
            VStack {
                VStack {
                    HStack {

                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .background(.white.opacity(0.5))
                    .allowsHitTesting(false)

                    HStack(spacing: 0) {
                        ForEach(0..<3) { index in
                            Button(action: {
                                self.selection = index
                            }) {
                                VStack {
                                    Text("Page")
                                }
                                .frame(width: UIScreen.main.bounds.width/3.0 , height: 30)
                                .background(self.selection == index ? Color.orange : Color.gray)
                                .cornerRadius(10)
                            }
                        }
                    }
                }
                .offset(y: -paddingTop)     // ⭐



                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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

struct Model: Identifiable {
    var id: String = UUID().uuidString
    var title: String
}




struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        let next = nextValue()
//        print("✅", value, next)
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
