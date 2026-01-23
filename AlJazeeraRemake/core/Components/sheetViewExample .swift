//
//  sheetViewExample .swift
//  AlJazeeraRemake
//
//  Created by Syed Abrar Shah on 21/01/2026.
//

import SwiftUI


struct SheetView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button("Press to dismiss"){
            dismiss()
        }
        .font(.title)
        .foregroundStyle(Color.white)
        .padding()
        .background(Color.black)
    }
}

struct sheetViewExample_: View {
    
    @State private var isSheetPresented: Bool = false
    
    var body: some View {
        Button("Show Sheet"){
            isSheetPresented.toggle()
        }
        .foregroundStyle(Color.blue)
        .sheet(isPresented: $isSheetPresented){
            SheetView() // Cannot present 2 sheets from one parent and can only show another sheet from inside the first sheet. For multiple screens we can use navigationView.
            //        .fullScreenCover(isPresented: $isSheetPresented, content: SheetView.init)
        }
    }
}
#Preview {
    sheetViewExample_()
}
