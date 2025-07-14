//
//  Date+Ext.swift
//  BookWithMe
//
//  Created by 계은성 on 5/6/25.
//

import Foundation

extension Date {
    static func startAndEndOfMonth(for date: Date = Date()) -> (startOfMonth: Date, endOfMonth: Date)? {
        let calendar = Calendar.current
        
        // 해당 날짜의 월, 연도 추출
        let components = calendar.dateComponents([.year, .month], from: date)
        
        guard
            // 해당 월의 1일 0시 0분 0초
            let startOfMonth = calendar.date(
                from: DateComponents(year: components.year,
                                     month: components.month,
                                     day: 1,
                                     hour: 0,
                                     minute: 0,
                                     second: 0)
            ),
            // 해당 월의 마지막 날 구하기
            let range = calendar.range(of: .day, in: .month, for: startOfMonth),
            let lastDay = range.last,
            
            // 마지막 날 23시 59분 59초
            let endOfMonth = calendar.date(
                from: DateComponents(year: components.year,
                                     month: components.month,
                                     day: lastDay,
                                     hour: 23,
                                     minute: 59,
                                     second: 59))
        else { return nil }
        
        return (startOfMonth, endOfMonth)
    }
    
    /// 한국 시간 기준 Calendar
    private static var koreaCalendar: Calendar {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        return calendar
    }

    /// 한국 시간 기준으로 지금이 월요일인지 여부
    static func isMonday(date: Date = Date()) -> Bool {
        let weekday = koreaCalendar.component(.weekday, from: date)
        return weekday == 2
    }
}
