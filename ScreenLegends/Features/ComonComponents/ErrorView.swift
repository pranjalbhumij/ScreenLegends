//
//  ErrorView.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 11/02/25.
//

import SwiftUI

struct ErrorView: View {
    var errorDescription: String
    
    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()
            VStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                
                Text(errorDescription)
            }
        }
    }
}
#Preview {
    ErrorView(errorDescription: "Something went wrong")
}
