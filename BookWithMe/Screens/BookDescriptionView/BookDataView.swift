//
//  BookDataView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/8/25.
//

import SwiftUI

struct BookDataView: View {
    @State var descriptionViewModel: BookDescriptionViewModel = BookDescriptionViewModel(book: Book.DUMMY_BOOK)

    
    var body: some View {
        VStack(spacing: 10) {
            
            BookDescriptionView(
                viewModel: self.descriptionViewModel)
            if !self.descriptionViewModel.isPreviewMode {
                BookHistoryView(history: BookHistory.DUMMY_BOOKHISTORY)
            }
            Spacer()
            if self.descriptionViewModel.isPreviewMode {
                self.bottomButton
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .background(Color.baseBackground)
        
    }
}


private extension BookDataView {
    var bottomButton: some View {
        return Button {
            print("bottomButton_Tapped")
            
            self.descriptionViewModel.descriptionModeToggle()
        } label: {
            Text("나의 책장에 저장하기")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.black)
        }
        .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 120)
        .background(Color.baseButton)
        .roundedTopCorners()
        .defaultShadow()
        .transition(.move(edge: .bottom))
    }
}
#Preview {
    BookDataView()
}
