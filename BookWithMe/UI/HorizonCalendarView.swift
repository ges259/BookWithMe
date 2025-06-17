//
//  HorizonCalendarView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/12/25.
//

import SwiftUI
import HorizonCalendar

// MARK: - DaySelectionStatus 구조체
/// 날짜 셀의 '상태'와 그 상태에 따른 '색상'을 함께 캡슐화한 struct
struct DaySelectionStatus {
    /// 시작일
    let isStart: Bool
    /// 종료일
    let isEnd: Bool
    /// 시작일과 종료일 사이에 껴 있는 날짜
    let inRange: Bool
    /// '시작일' 또는 '종료일'을 알려줌
    let selectionMode: SelectionMode

    
    /// 선택 중인 날짜의 메인 색상
    private let primaryHighlightColor: Color = .red
    /// 다른 쪽 날짜의 보조 색상
    private let secondaryHighlightColor: Color = .blue
    /// 범위 내 날짜들의 흐릿한 색상
    private let rangeColor: Color = Color.blue.opacity(0.2)
    
    
    /// 날짜의 배경색
    /// 상태와 선택 모드에 따라 알아서 정해줌
    var backgroundColor: Color {
        switch selectionMode {
        case .start: // 지금 '시작일'을 고르는 모드라면
            if isStart {
                return primaryHighlightColor
            } else if isEnd {
                return secondaryHighlightColor
            }
        case .end: // 지금 '종료일'을 고르는 모드라면
            if isEnd {
                return primaryHighlightColor
            } else if isStart {
                return secondaryHighlightColor
            }
        }
        // 시작일/종료일 둘 다 아니고, 범위 안에 있다면 흐릿한 파란색
        // 아니면 그냥 투명하게.
        return inRange ? rangeColor : Color.clear
    }
    
    /// 날짜의 글자색
    /// 시작일이나 종료일이면 글씨를 흰색으로 바꿔서 잘 보이게 해줌
    var foregroundColor: Color {
        return isStart || isEnd ? .white : .black
    }
    
    /// DaySelectionStatus를 편리하게 만들 수 있는 이니셜라이저
    /// 이 날짜가 어떤 날짜인지, 어떤 캘린더를 쓰는지, 시작/종료일이 뭔지, 어떤 모드인지 알려주면
    /// 알아서 `isStart`, `isEnd`, `inRange`를 계산해줌
    init(date: Date,
         calendar: Calendar,
         startDate: Date?,
         endDate: Date?,
         selectionMode: SelectionMode
    ) {
        // 이 날짜가 시작일과 같은 날짜인지 확인
        self.isStart = startDate.map { calendar.isDate($0, inSameDayAs: date) } ?? false
        // 이 날짜가 종료일과 같은 날짜인지 확인
        self.isEnd = endDate.map { calendar.isDate($0, inSameDayAs: date) } ?? false
        
        // 이 날짜가 시작일과 종료일 사이에 있는지 복잡하게 계산
        // guard let으로 안전하게 시작일, 종료일이 있는지 확인하고 아니면 바로 false 반환
        self.inRange = {
            guard
                let start = startDate,
                let end = endDate
            else { return false }
            // 'date > start && date < end'는 시작일과 종료일을 포함하지 않고 '사이'만 나타냄
            // 만약 시작일과 종료일도 범위에 포함하고 싶다면 'date >= start && date <= end'로 바꾸면 됨
            return date > start && date < end
        }()
        
        self.selectionMode = selectionMode
    }
}










// MARK: - HorizonCalendarView
struct HorizonCalendarView: UIViewRepresentable {
    /// 시작일 바인딩
    @Binding var startDate: Date?
    /// 종료일 바인딩
    @Binding var endDate: Date?
    /// 날짜 선택 모드 (시작일 선택 중인지, 종료일 선택 중인지)
    var selectionMode: SelectionMode
    
    /// UIView를 처음 만들 때 딱 한 번 호출되는 함수
    func makeUIView(context: Context) -> CalendarView {
        // 캘린더 뷰를 만들고 초기 내용 채우기
        let calendarView = CalendarView(initialContent: makeContent())
        
        // 캘린더가 나타나자마자 오늘 날짜가 있는 달로 스크롤
        // DispatchQueue.main.async를 쓰는 건, UI가 다 그려지고 나서 스크롤해야 제대로 작동하기 때문
        DispatchQueue.main.async {
            let today = Date()
            calendarView.scroll(
                toMonthContaining: today,
                scrollPosition: .firstFullyVisiblePosition(padding: 0),
                animated: false // 애니메이션 없이
            )
        }
        
        // 캘린더에서 어떤 날짜를 눌렀을 때 무슨 일이 일어날지 정하는 핸들러
        calendarView.daySelectionHandler = { day in
            
            let calendar = Calendar.current
            // DayComponents를 우리가 아는 Date 타입으로 바꿔줘!
            guard let tappedDate = calendar.date(from: day.components) else { return }
            
            self.handleDateSelection(for: tappedDate) // 날짜 선택 로직은 따로 함수로 뺐어! 깔끔하지?
            
            // 날짜 선택 후 캘린더 뷰를 다시 그려줘! (선택된 날짜 색깔 바뀌게!)
            self.updateUIView(calendarView, context: context) // makeContent() 대신 updateUIView를 명시적으로 호출
        }
        
        return calendarView
    }
    
    /// SwiftUI 데이터가 변했을 때 UIView를 업데이트해주는 함수
    /// 여기서는 makeContent()를 다시 호출해서 캘린더 내용을 통째로 업데이트해줌
    func updateUIView(
        _ uiView: CalendarView,
        context: Context
    ) {
        uiView.setContent(makeContent())
    }
}


    
// MARK: - 날짜 선택 처리 로직
extension HorizonCalendarView {
    private func handleDateSelection(for tappedDate: Date) {
        // 1. 만약 시작일과 종료일이 '모두' 설정된 상태라면 -> '범위' 안에서 날짜를 선택하는 로직을 처리
        if let start = startDate, let end = endDate {
            handleSelectionWhenRangeIsSet(tappedDate, currentStart: start, currentEnd: end)
        }
        
        // 2. 만약 시작일이나 종료일이 '아직' 설정되지 않은 상태라면 -> 새로운 시작 또는 종료 날짜를 설정
        else {
            handleInitialOrSingleDateSelection(tappedDate)
        }
    }

    /// 캘린더를 처음 누르거나, 시작일/종료일 중 하나만 있을 때 호출되는 함
    private func handleInitialOrSingleDateSelection(_ tappedDate: Date) {
        switch selectionMode {
        case .start:
            startDate = tappedDate // 시작일 모드면 탭한 날짜를 시작일로!
        case .end:
            endDate = tappedDate   // 종료일 모드면 탭한 날짜를 종료일로!
        }
    }

    /// 시작일과 종료일이 모두 설정된 상태에서 날짜 선택 처리
    private func handleSelectionWhenRangeIsSet(
        _ tappedDate: Date,
        currentStart start: Date,
        currentEnd end: Date
    ) {
        if tappedDate < start { // 탭한 날짜가 현재 시작일보다 이전이라면?
            // 시작일 이전 탭 시, 시작일/종료일 업데이트 로직 처리
            updateDatesOnTapBeforeOrAfterBoundary(tappedDate, currentBoundary: start, isBefore: true)
        } else if tappedDate > end { // 탭한 날짜가 현재 종료일보다 이후라면?
            // 종료일 이후 탭 시, 시작일/종료일 업데이트 로직 처리
            updateDatesOnTapBeforeOrAfterBoundary(tappedDate, currentBoundary: end, isBefore: false)
        } else { // 탭한 날짜가 현재 시작일과 종료일 '사이' 또는 '정확히' 시작/종료일이라면?
            // (범위 안에 있을 때)
            handleTapInsideOrOnBoundary(tappedDate)
        }
    }
    
    
    /// 날짜 선택 범위의 시작일 또는 종료일 '바깥'을 탭했을 때,
    /// 선택 모드와 탭 위치에 따라 `startDate`와 `endDate`를 업데이트하는 함수
    ///
    /// - Parameters:
    ///   - tappedDate: 사용자가 탭한 날짜
    ///   - currentBoundary: 현재 선택된 시작일 또는 종료일 (기준이 되는 경계).
    ///   - isBefore: `tappedDate`가 `currentBoundary`보다 이전인지 여부 (`true`이면 이전, `false`이면 이후).
    private func updateDatesOnTapBeforeOrAfterBoundary(
        _ tappedDate: Date,
        currentBoundary: Date,
        isBefore: Bool
    ) {
        switch selectionMode {
        // 시작일 모드일 때
        case .start:
            // 시작일 이전을 탭했다면
            if isBefore {
                // 시작일만 갱신
                startDate = tappedDate
                
            // 종료일 이후를 탭했다면 (범위 뒤집힘)
            } else {
                // 현재 종료일이 새로운 시작일이 되고
                startDate = currentBoundary
                // 탭한 날짜가 새로운 종료일이 됨
                endDate = tappedDate
            }
            
        // 종료일 모드일 때
        case .end:
            // 시작일 이전을 탭했다면 (범위 뒤집힘)
            if isBefore {
                // 탭한 날짜가 새로운 시작일이 되고
                startDate = tappedDate
                // 현재 시작일이 새로운 종료일이 됨
                endDate = currentBoundary
                
            // 종료일 이후를 탭했다면
            } else {
                // 종료일만 갱신
                endDate = tappedDate
            }
        }
    }

    /// 현재 시작일과 종료일 '안' 또는 '경계'를 탭했을 때
    private func handleTapInsideOrOnBoundary(_ tappedDate: Date) {
        switch selectionMode {
        // 시작일 모드라면 시작일만 바꿔줌
        case .start:
            startDate = tappedDate
            
        // 종료일 모드라면 종료일만 바꿔줌
        case .end:
            endDate = tappedDate
        }
    }
}










// MARK: - makeContent
// 캘린더의 내용물(달력 범위, 날짜/월 헤더 뷰 등)을 만드는 확장
extension HorizonCalendarView {
    private func makeContent() -> CalendarViewContent {
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
