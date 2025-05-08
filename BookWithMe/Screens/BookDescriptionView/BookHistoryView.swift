//
//  BookHistoryView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/8/25.
//

import SwiftUI

struct BookHistoryView: View {
    
    let history: BookHistory
    private let labelWidth: CGFloat = 60 // 제목 고정 너비
    
    var body: some View {
        VStack(spacing: 0) {
            self.header
            ForEach(BookInfoRow.allCases) { row in
                
                HStack(alignment: .top, spacing: 20) {
                    self.rowTitle(row)
                    self.detailText(row)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    print("\(row.title) tapped")
                }
            }
        }
        .background(Color.contentsBackground1)
        .defaultCornerRadius()
        .defaultShadow()
        .padding(.horizontal)
    }
}

private extension BookHistoryView {
    var header: some View {
        return HStack {
            Text("나의 기록")
                .font(.title2)
                .frame(height: 70)
            Spacer()
            Image.chevronRight
        }
        .padding(.horizontal)
    }
    
    
    
    func rowTitle(_ row: BookInfoRow) -> some View {
        return Text(row.title)
            .frame(width: labelWidth,
                   height: 50,
                   alignment: .leading)
            .padding(.horizontal, 20)
            .background(Color.contentsBackground2)
            .font(.subheadline)
            .foregroundColor(.black)
            .if(row == .status) { view in
                view.roundedTopTrailingCorners()
            }
    }
    func detailText(_ row: BookInfoRow) -> some View {
        return Text(valueText(for: row))
            .font(.body)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 50)
    }
    
    
    
    
    func valueText(for row: BookInfoRow) -> String {
        switch row {
        case .status:
            return history.status.rawValue
        case .period:
            return "\(formatted(history.startDate)) ~ \(formatted(history.endDate))"
        case .rating:
            return history.review.map { "\($0.rating)점" } ?? "-"
        case .summary:
            return history.review?.review_summary ?? "-"
        case .tags:
            return history.review?.tags.joined(separator: ", ") ?? "-"
        }
    }
    
    private func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    BookHistoryView(history: BookHistory.DUMMY_BOOKHISTORY)
}

