//
//  AlphaView.swift
//  TabViewMyPageExample
//
//  Created by 長内幸太郎 on 2023/06/21.
//

import SwiftUI

struct AlphaView: View {

    var models: [Model] = [
        Model(title: "1"),
        Model(title: "2"),
        Model(title: "3"),
        Model(title: "4"),
        Model(title: "5"),
        Model(title: "6"),
        Model(title: "7"),
        Model(title: "8"),
        Model(title: "9"),
        Model(title: "10"),
        Model(title: "11"),
        Model(title: "12"),
        Model(title: "13"),
        Model(title: "14"),
        Model(title: "15"),
        Model(title: "16"),
        Model(title: "17"),
        Model(title: "18"),
        Model(title: "19"),
        Model(title: "20"),
    ]

    var tabViewIndex: Int               // この画面の位置
    var headerHeight: CGFloat           // Headerのスクロールする部分の高さ
    var tabHeight: CGFloat              // 残す部分の高さ

    @Binding var selection: Int         // 現在表示されている画面
    @Binding var scrollOffsetForAlpha: CGFloat
    @Binding var scrollOffsetForBeta: CGFloat
    @Binding var scrollOffsetForOmega: CGFloat
    @Binding var paddingTop: CGFloat
    @Binding var customOnAppear: Bool   // こちらで作成したonAppearタイミング

    private var isShowingThisScreen: Bool {
        selection == tabViewIndex
    }

    private var topSpacing: CGFloat {
        headerHeight + tabHeight
    }

    var body: some View {
        innerView
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private extension AlphaView {

    @ViewBuilder
    var innerView: some View {
        ScrollViewReader { scrollProxy in
            GeometryReader { geometryProxy in
                ScrollView {
                    VStack(spacing: 0) {
                        // スクロール位置を得るための起点と、スクロール量を指定するためのView
                        scrollAnchor
                        // Paddingのためのダミー
                        dummyTopView
                    }

                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 10, alignment: .center),
                        GridItem(.flexible(), spacing: 10, alignment: .center),
                    ]) {
                        mainContents
                    }
                }
                .coordinateSpace(name: "scrollView")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { scroll in
                    // 現在表示中の画面ならば
                    if isShowingThisScreen {
                        paddingTop = min(scroll, headerHeight - 0.1)
                        scrollOffsetForAlpha = scroll

                        if scroll < headerHeight - 0.1 {
                            // 他の画面のスクロール量をリセット
                            scrollOffsetForBeta = scroll
                            scrollOffsetForOmega = scroll
                        }
                        else {
                            // スクロール量を維持か、上に隙間が空く場合はHeaderに吸い付かせる
                            scrollOffsetForBeta = max(scrollOffsetForBeta, min(scroll, headerHeight - 0.1))
                            scrollOffsetForOmega = max(scrollOffsetForOmega, min(scroll, headerHeight - 0.1))
                        }
                    }
                }
                .onAppear {
                    // scroll量を調整するため
                    // ただし、割合でしか指定できないので、スクロール量からUnitPointを計算してしていしている
                    let unitPoint = UnitPoint.calcUnitPointY(y: -scrollOffsetForAlpha, scrollViewHeight: geometryProxy.size.height)
                    scrollProxy.scrollTo("TopPadding", anchor: UnitPoint(x: 0.5, y: unitPoint))
                }
            }
        }
    }

    // スクロール位置を得るための起点と、スクロール量を指定するためのView
    @ViewBuilder
    var scrollAnchor: some View {
        VStack {
        }
        .frame(width: UIScreen.main.bounds.width, height: 0.1)
        .background(.clear)
        .id("TopPadding")
        .background(GeometryReader {
            Color.clear.preference(key: ScrollOffsetPreferenceKey.self,
                                   value: -$0.frame(in: .named("scrollView")).origin.y)
        })
    }

    @ViewBuilder
    var dummyTopView: some View {
        VStack {
        }
        .frame(width: UIScreen.main.bounds.width, height: headerHeight)
        .background(.gray.opacity(0.5))
    }

    @ViewBuilder
    var mainContents: some View {
        ForEach(models) { model in
            Cell(title: model.title)
                .frame(width: 150, height: 150)
                .onTapGesture {
                }
        }
    }
}

