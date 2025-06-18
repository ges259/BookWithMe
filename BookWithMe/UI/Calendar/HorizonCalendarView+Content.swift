//
//  HorizonCalendarView+Content.swift
//  BookWithMe
//
//  Created by 계은성 on 6/19/25.
//

import SwiftUI
import HorizonCalendar


// MARK: - makeContent
// 캘린더의 내용물(달력 범위, 날짜/월 헤더 뷰 등)을 만드는 확장
extension HorizonCalendarView {
    func makeContent() -> CalendarViewContent {
        return makeCalendarContentConfigurator()
            .dayItemProvider { day in
                self.dayItem(day: day,
                             calendar: Calendar.current
                )
                .calendarItemModel
            }
            .monthHeaderItemProvider { month in
                self.monthHeaderView(
                    for: month,
                    calendar: Calendar.current
                )
                .calendarItemModel
            }
    }
    
    /// 캘린더의 기본 구성 (보이는 범위, 스크롤 방식 등)을 정의하는 함수
    private func makeCalendarContentConfigurator() -> CalendarViewContent {
        let calendar = Calendar.current // 현재 캘린더 가져오기 (얘가 날짜 계산 다 해줌)
        // 오늘 날짜 기준으로 앞뒤로 3달씩 보여줄 거야! 너무 많이 보여줄 필요는 없잖아?
        let start = calendar.date(byAdding: .month, value: -3, to: Date())!
        let end = calendar.date(byAdding: .month, value: 3, to: Date())!
        
        return CalendarViewContent(
            // 어떤 캘린더를 쓸지 명시
            calendar: calendar,
            // 캘린더에 보여줄 날짜 범위를 설정
            visibleDateRange: start...end,
            // 달별 레이아웃은 옆으로 넘기는 방식
            monthsLayout: .horizontal(options: .init(
                // 페이지 넘기듯이 한 달씩 딱딱 끊어서 스크롤
                scrollingBehavior: .paginatedScrolling(
                    HorizontalMonthsLayoutOptions.PaginationConfiguration(
                        // 스크롤 멈췄을 때 각 달의 시작 부분에 딱 맞게
                        restingPosition: .atLeadingEdgeOfEachMonth,
                        // 스크롤 끝났을 때 가장 가까운 달로 자연스럽게
                        restingAffinity: .atPositionsClosestToTargetOffset
                    )))
            )
        )
    }
    
    /// 개별 날짜 셀 뷰를 만드는 함수
    private func dayItem(
        day: DayComponents,
        calendar: Calendar
    ) -> some View {
        // DayComponents를 Date로 변환
        let date = calendar.date(from: day.components)!
        
        // DaySelectionStatus 구조체를 생성해서 이 날짜의 모든 상태와 색상을 한방에 가져옴
        let status = DaySelectionStatus(
            date: date,
            calendar: calendar,
            startDate: self.startDate, // 뷰의 @Binding startDate를 전달
            endDate: self.endDate,     // 뷰의 @Binding endDate를 전달
            selectionMode: self.selectionMode // 뷰의 selectionMode를 전달
        )
        
        // Text 뷰에 status 객체에서 알아서 가져온 배경색이랑 글자색 적용
        return Text("\(day.day)") // '몇 일'인지 표시
            .frame(width: 36, height: 36) // 날짜 셀 크기 고정
            .background(status.backgroundColor) // status가 알려준 배경색 적용
            .cornerRadius(8) // 모서리 둥글게
            .foregroundColor(status.foregroundColor) // status가 알려준 글자색 적용
    }
    
    // "yyyy년 M월" 형식으로 월 표시를 해주는 뷰를 만들어줌
    func monthHeaderView(
        for month: MonthComponents,
        calendar: Calendar
    ) -> some View {
        // MonthComponents를 Date로 변환
        let date = calendar.date(from: month.components)!
        // 날짜 형식을 바꿔줌
        let formatter = DateFormatter()
        // 한국어로
        formatter.locale = Locale(identifier: "ko_KR")
        // 날짜 형시 설정, ex) 2023년 5월
        formatter.dateFormat = "yyyy년 M월"
        
        return Text(formatter.string(from: date)) // 포맷팅된 텍스트
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 8)
    }
}
