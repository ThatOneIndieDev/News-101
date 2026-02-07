//
//  AlJazeera Logo.swift
//  AlJazeeraRemake
//
//  Created by Syed Abrar Shah on 12/01/2026.
//

import SwiftUI

struct AlJazeera_Logo: View {
    var body: some View {
        ZStack {
            HStack {
                logo_Image
                logo_Text
                Spacer()
            }
            .padding()
        }
    }
}

extension AlJazeera_Logo{
    private var logo_Image: some View{
        Image(systemName: "newspaper.fill")
            .font(.system(size: 26, weight: .bold))
            .foregroundStyle(Color(.secondaryLabel))
    }
    private var logo_Text: some View{
        Text("News 101")
            .font(.title2.weight(.semibold))
            .foregroundStyle(Color(.secondaryLabel))
            .padding(.leading)
    }
}

#Preview {
    AlJazeera_Logo().colorScheme(.dark)
}
