//
//  EmptyView.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 11/02/25.
//

import SwiftUI

struct EmptyView: View {
    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()
            VStack {
                Image(systemName: "doc.text.magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                
                Text("No Data")
            }
        }
    }
}

#Preview {
    EmptyView()
}
