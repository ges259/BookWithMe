//
//  DaySelectionStatus.swift
//  BookWithMe
//
//  Created by 계은성 on 6/19/25.
//

import SwiftUI

// MARK: - DaySelectionStatus
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
