//
//  ContentView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/4/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: TabItem = .bookShelf
    
    var body: some View {
        MainTapView(selectedTab: $selectedTab)
    }
}

#Preview {
    ContentView()
}
