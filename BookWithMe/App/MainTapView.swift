//
//  MainTapView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

struct MainTapView: View {
    @Binding var selectedTab: TabItem

    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                ForEach(TabItem.allCases, id: \.self) { tab in
                    tab.view
                        .tag(tab)
                        .background(Color.baseBackground)
                        .tabItem { tab.iconImage.tint(Color.red) }
                }
            }
            .tint(Color.baseButton)
            .navigationTitle(selectedTab.navTitle)
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}

#Preview {
    @State var selectedTab: TabItem = .bookShelf
    return MainTapView(selectedTab: $selectedTab)
}
