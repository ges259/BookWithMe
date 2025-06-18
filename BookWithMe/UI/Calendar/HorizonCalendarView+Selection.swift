//
//  HorizonCalendarView+Selection.swift
//  BookWithMe
//
//  Created by 계은성 on 6/19/25.
//

import Foundation

// MARK: - 날짜 선택 처리 로직
extension HorizonCalendarView {
    func handleDateSelection(for tappedDate: Date) {
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
