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
        Image("Al Jazeera Logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 40)
    }
    private var logo_Text: some View{
        Text("Al Jazeera")
            .font(.custom("Typeface", size: 24, relativeTo: .headline))
            .foregroundStyle(Color(.secondaryLabel))
            .padding(.leading)
    }
}

#Preview {
    AlJazeera_Logo().colorScheme(.dark)
}
