//
//  HistoryTermView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/10/25.
//
import SwiftUI
import HorizonCalendar

struct HistoryTermView: View {
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    
    var selectionMode: SelectionMode
    
    var body: some View {
        VStack {
            self.headerView
            self.selectedDateText
            self.horizonCalendarView
        }
        .padding()
    }
}



// MARK: - UI
private extension HistoryTermView {

    var headerView: some View {
        HeaderTitleView(
            title: "\(self.selectionMode.dateSelectionLabel)을 선택해 주세요",
            appFont: .historyTermHeader,
            alignment: .center
        )
    }
    
    var horizonCalendarView: some View {
        return HorizonCalendarView(
            startDate: $startDate,
            endDate: $endDate,
            selectionMode: selectionMode
        )
        .frame(maxWidth: .infinity)
        .frame(height: 400)
        .defaultCornerRadius()
    }
    
    var bottomButtonView: some View {
        return Button {
            print("bottomButton")
        } label: {
            Text("저장하기")
                .frame(maxWidth: .infinity, maxHeight: 50)
                .foregroundStyle(Color.black)
                .contentShape(Rectangle()) // 터치 영역 확장
        }
        .background(Color.contentsBackground1)
    }
    
    var selectedDateText: some View {
        if let start = startDate, let end = endDate {
            return Text("선택된 범위: \(format(start)) ~ \(format(end))")
        } else if let start = startDate {
            return Text("선택된 시작일: \(format(start))")
        } else if let end = endDate {
            return Text("선택된 종료일: \(format(end))")
        } else {
            return Text("날짜를 선택해 주세요.")
        }
    }

    func format(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
