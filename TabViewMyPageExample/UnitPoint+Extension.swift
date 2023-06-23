//
//  UnitPoint+Extension.swift
//  TabViewMyPageExample
//
//  Created by 長内幸太郎 on 2023/06/23.
//

import Foundation
import SwiftUI

extension UnitPoint {
    // 例: yが100, scrollViewHeightが400, なら、targetViewの高さがゼロの場合、y/scrollViewHeight
    static func calcUnitPointY(y: CGFloat,
                               scrollViewHeight: CGFloat) -> CGFloat {
        y / scrollViewHeight
    }
}
