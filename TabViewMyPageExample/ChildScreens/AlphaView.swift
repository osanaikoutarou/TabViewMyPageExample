//
//  AlphaView.swift
//  TabViewMyPageExample
//
//  Created by 長内幸太郎 on 2023/06/21.
//

import SwiftUI

extension UnitPoint {
    // 例: yが100, scrollViewHeightが400, なら、targetViewの高さがゼロの場合、y/scrollViewHeight
    static func calcUnitPointY(y: CGFloat,
                               scrollViewHeight: CGFloat) -> CGFloat {
        y / scrollViewHeight
    }
}

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

    @Binding var scrollOffsetForAlpha: CGFloat
    @Binding var scrollOffsetForBeta: CGFloat
    @Binding var scrollOffsetForOmega: CGFloat
    @Binding var paddingTop: CGFloat

    @Binding var selection: Int

    @Binding var customOnAppear: Bool

    var body: some View {
        grid.frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    var grid: some View {
        ScrollViewReader { scrollProxy in
            GeometryReader { geometryProxy in
                ScrollView {
                    VStack(spacing: 0) {
                        VStack {
                        }
                        .frame(width: 320, height: 0.1)
                        .background(.purple)
                        .id("TopPadding")

                        VStack {
                        }
                        .frame(width: 320, height: 300)
                        .background(.gray.opacity(0.5))
                        .background(GeometryReader {
                            // 最上部につける
                            Color.clear.preference(key: ScrollOffsetPreferenceKey.self,
                                                   value: -$0.frame(in: .named("scrollView")).origin.y)
                        })
                    }

                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 10, alignment: .center),
                        GridItem(.flexible(), spacing: 10, alignment: .center),
                    ]) {
                        ForEach(models) { model in
                            Cell(title: model.title)
                                .frame(width: 150, height: 150)
                                .onTapGesture {
                                }
                        }
                    }

                }
                .padding(.all, 0)
                .coordinateSpace(name: "scrollView")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { scroll in
                    print("🍋", offset, selection)
                    if selection == 0 {
                        paddingTop = min(scroll, 250)
                        scrollOffsetForAlpha = scroll

                        if scroll < 250 {
                            // リセット
                            scrollOffsetForBeta = scroll
                            scrollOffsetForOmega = scroll
                        }
                        else {
                            scrollOffsetForBeta = max(scrollOffsetForBeta, min(scroll, 250))
                            scrollOffsetForOmega = max(scrollOffsetForOmega, min(scroll, 250))
                        }
                    }
                    else {
                        print("🐢", "in Alpha selection == ", selection, scroll)
                    }


                }
                .onAppear {
                    print("🐙", "Alpha")
                    scrollProxy.scrollTo(
                        "TopPadding",
                        anchor: UnitPoint(x: 0.5,
                                          y: UnitPoint.calcUnitPointY(y: -scrollOffsetForAlpha,
                                                                      scrollViewHeight: geometryProxy.size.height))
                    )
                }
            }
        }
        .onChange(of: customOnAppear) { newValue in
            if newValue {
                print("⭐⭐⭐ onAppearAlpha")
            }
        }
    }
}

