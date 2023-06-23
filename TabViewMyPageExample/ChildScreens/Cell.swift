//
//  Cell.swift
//  TabViewMyPageExample
//
//  Created by 長内幸太郎 on 2023/06/21.
//

import SwiftUI

struct Cell: View {
    var title: String
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(title)
                Spacer()
            }
            Spacer()
        }
        .background(.black.opacity(0.2))
    }
}

struct Cell_Previews: PreviewProvider {
    static var previews: some View {
        Cell(title: "abc")
    }
}
