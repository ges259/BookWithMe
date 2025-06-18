//
//  HorizonCalendarView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/12/25.
//

import SwiftUI
import HorizonCalendar

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
