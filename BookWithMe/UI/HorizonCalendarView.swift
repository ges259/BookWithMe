//
//  HorizonCalendarView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/12/25.
//

import SwiftUI
import HorizonCalendar

struct HorizonCalendarView: UIViewRepresentable {
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    
    var selectionMode: SelectionMode

    func makeUIView(context: Context) -> CalendarView {
        let calendarView = CalendarView(initialContent: makeContent())

        calendarView.daySelectionHandler = { day in
            let calendar = Calendar.current
            guard let tappedDate = calendar.date(from: day.components) else { return }

            switch selectionMode {
            case .start:
                if let currentStart = startDate, calendar.isDate(currentStart, inSameDayAs: tappedDate) {
                    // startDate가 같은 날짜면 취소
                    startDate = nil
                } else {
                    // startDate만 갱신 (endDate는 그대로 둠)
                    startDate = tappedDate
                }

            case .end:
                if let currentEnd = endDate, calendar.isDate(currentEnd, inSameDayAs: tappedDate) {
                    // endDate가 같은 날짜면 취소
                    endDate = nil
                } else {
                    // endDate만 갱신 (startDate는 그대로 둠)
                    endDate = tappedDate
                }
            }

            calendarView.setContent(makeContent())
        }
        return calendarView
    }

    func updateUIView(_ uiView: CalendarView, context: Context) {
        uiView.setContent(makeContent())
    }

    private func makeContent() -> CalendarViewContent {
        let calendar = Calendar.current
        let start = calendar.date(byAdding: .month, value: -3, to: Date())!
        let end = calendar.date(byAdding: .month, value: 3, to: Date())!

        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: start...end,
            monthsLayout: .horizontal(options: .init(scrollingBehavior: .paginatedScrolling(
                HorizontalMonthsLayoutOptions.PaginationConfiguration(
                    restingPosition: .atLeadingEdgeOfEachMonth,
                    restingAffinity: .atPositionsClosestToTargetOffset
                )
            )))
        )
        .dayItemProvider { day in
            let date = calendar.date(from: day.components)!
            let isStart = startDate.map { calendar.isDate($0, inSameDayAs: date) } ?? false
            let isEnd = endDate.map { calendar.isDate($0, inSameDayAs: date) } ?? false
            let inRange = {
                guard let start = startDate, let end = endDate else { return false }
                return date > start && date < end
            }()

            return Text("\(day.day)")
                .frame(width: 36, height: 36)
                .background(isStart || isEnd ? Color.blue :
                            inRange ? Color.blue.opacity(0.2) : Color.clear)
                .cornerRadius(8)
                .foregroundColor(isStart || isEnd ? .white : .black)
                .calendarItemModel
        }
        .monthHeaderItemProvider { month in
            let date = calendar.date(from: month.components)!
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yyyy년 M월"

            return Text(formatter.string(from: date))
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)
                .calendarItemModel
        }
    }
}
