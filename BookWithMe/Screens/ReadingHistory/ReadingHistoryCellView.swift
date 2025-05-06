//
//  ReadingHistoryCellView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/6/25.
//

import SwiftUI

struct ReadingHistoryCellView: View {
    
    let viewModel: BookShelfCellViewModel
    
    
    var body: some View {
        VStack {
            self.header
            ScrollView {
                self.lazyVGrid
            }
        }
        .padding(.horizontal)
        .background(Color.contentsBackground1)
        .clipShape(RoundedRectangle(cornerRadius: BookShelfUI.cornerRadius))
    }
}

private extension ReadingHistoryCellView {
    var header: some View {
        HeaderTitleView(title: "ReadingHistoryView", showChevron: false)
    }
    
    var lazyVGrid: some View {
        return LazyVGrid(
            columns: ReadingHistoryUI.columns,
            alignment: .leading,
            spacing: 20
        ) {
            ForEach(viewModel.bookArray, id: \.bookId) { book in
                BookCardView(imageURL: book.imageString)
            }
        }
        
    }
}

#Preview {
    ReadingHistoryCellView(
        viewModel: BookShelfCellViewModel(readingStatus: .reading)
    )
}



/*
 
 
 RoundedRectangle(cornerRadius: 8)
           .fill(Color.blue.opacity(0.3))
           .frame(height: 80)
           .overlay(Text("타이틀"))
 RoundedRectangle(cornerRadius: 8)
           .fill(Color.blue.opacity(0.3))
           .frame(height: 80)
           .overlay(Text("타이틀"))
 RoundedRectangle(cornerRadius: 8)
           .fill(Color.blue.opacity(0.3))
           .frame(height: 80)
           .overlay(Text("타이틀"))
 RoundedRectangle(cornerRadius: 8)
           .fill(Color.blue.opacity(0.3))
           .frame(height: 80)
           .overlay(Text("타이틀"))
 RoundedRectangle(cornerRadius: 8)
           .fill(Color.blue.opacity(0.3))
           .frame(height: 80)
           .overlay(Text("타이틀"))
 RoundedRectangle(cornerRadius: 8)
           .fill(Color.blue.opacity(0.3))
           .frame(height: 80)
           .overlay(Text("타이틀"))
 RoundedRectangle(cornerRadius: 8)
           .fill(Color.blue.opacity(0.3))
           .frame(height: 80)
           .overlay(Text("타이틀"))
 RoundedRectangle(cornerRadius: 8)
           .fill(Color.blue.opacity(0.3))
           .frame(height: 80)
           .overlay(Text("타이틀"))
 RoundedRectangle(cornerRadius: 8)
           .fill(Color.blue.opacity(0.3))
           .frame(height: 80)
           .overlay(Text("타이틀"))
 RoundedRectangle(cornerRadius: 8)
           .fill(Color.blue.opacity(0.3))
           .frame(height: 80)
           .overlay(Text("타이틀"))
 RoundedRectangle(cornerRadius: 8)
           .fill(Color.blue.opacity(0.3))
           .frame(height: 80)
           .overlay(Text("타이틀"))
 RoundedRectangle(cornerRadius: 8)
           .fill(Color.blue.opacity(0.3))
           .frame(height: 80)
           .overlay(Text("타이틀"))
 
 */
