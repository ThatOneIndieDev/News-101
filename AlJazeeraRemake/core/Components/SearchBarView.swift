//
//  SearchBarView.swift
//  AlJazeeraRemake
//
//  Created by Syed Abrar Shah on 21/01/2026.
//

import SwiftUI

struct SearchBarView: View {
    
    @FocusState private var isFocused: Bool
    
    @Binding var searchText: String
    
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    searchText.isEmpty ?  Color.white.opacity(0.5) : Color.blue

                )
                .padding(.leading)
            
            TextField("Search by name or symbol...", text: $searchText)
                .foregroundColor(Color.white)
                .disableAutocorrection(true)
                .focused($isFocused)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.red)
                        .padding() // Added padding to incease tapable area for the button.
                        .offset(x: 10)
                        .opacity(searchText.isEmpty ? 0.0: 1.0)
                        .onTapGesture {
                            searchText = ""
                            isFocused = false
                        },
                    alignment: .trailing
                )
        }
                .font(.headline)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white.opacity(0.1))
                        .shadow(
                            color: Color.blue.opacity(0.15),
                            radius: 10, x: 0, y: 0)
                )
                .padding()
        }
}

struct SearchBarView_Preview: PreviewProvider{
    static var previews: some View{
        SearchBarView(searchText: .constant(""))
    }
}
