//
//  SearchCellView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/7/25.
//

import SwiftUI

struct SearchCellView: View {
    let viewModel: SearchCellViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            BookCardView(imageURL: viewModel.imageUrl)

            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.bookTitle)
                    .font(.system(size: 15, weight: .semibold))

                Text(viewModel.bookAuthor)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .padding(.vertical, 8)
            Spacer()
        }
        .padding()
        .background(Color.contentsBackground1)
        .defaultCornerRadius()
        .defaultShadow()
        .padding(.horizontal)
    }
}






#Preview {
    SearchCellView(viewModel: SearchCellViewModel(book: Book.DUMMY_BOOK))
}
