//
//  CalendarDateFormatter.swift
//  CoNet
//
//  Created by 가은 on 2023/07/21.
//

import Foundation

class CalendarDateFormatter {
    private var calendar = Calendar.current // Calendar 구조체를 현재 달력으로 초기화
    private let dateFormatter = DateFormatter() // 원하는 String 타입으로 변화시켜줄 formatter
    private var nowCalendarDate = Date() // 현재 시간
    private(set) var days = [String]() // 달력에 표시할 날짜를 담을 배열
    
    init() {
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        
        configureCalendar()
    }
    
    // 오늘 날짜 Int 배열 
    func getToday() -> DateComponents {
        let calendarInfo = calendar.dateComponents([.year, .month, .day], from: Date())
        
        return calendarInfo
    }
    
    // 캘린더 날짜 Int 배열
    func getDate() -> [Int] {
        let calendarInfo = calendar.dateComponents([.year, .month, .day], from: nowCalendarDate)
        
        return [calendarInfo.year!, calendarInfo.month!, calendarInfo.day!]
    }
    
    // [Int] -> yyyy-mm-dd
    func changeDateType(date: [Int]) -> String {
        // year
        var returnDate = String(date[0])+"-"
        
        // month
        if date[1] < 10 {
            returnDate += "0"
        }
        returnDate += String(date[1])+"-"
        
        // day
        if date[2] < 10 {
            returnDate += "0"
        }
        returnDate += String(date[2])+"-"
        
        return returnDate
    }
    
    // year, month text
    func getYearMonthText() -> String {
        let date = getDate()
        let yearMonthText = String(date[0])+"년 "+String(date[1])+"월"
        
        return yearMonthText
    }
    
    // month text
    func getMonthText() -> String {
        let date = getDate()
        
        return String(date[1])
    }
    
    // 이번 달 날짜로 update
    func updateCurrentMonthDays() {
        days.removeAll()
        
        // 1일 요일
        let startDayOfWeek = getStartingDayOfWeek()
        let totalDaysOfMonth = startDayOfWeek + getEndDateOfMonth()
        
        for day in 0 ..< totalDaysOfMonth {
            if day < startDayOfWeek {
                days.append("")
                continue
            }
            days.append("\(day - startDayOfWeek + 1)")
        }
    }
    
    // 이전 달로
    func minusMonth() -> String {
        nowCalendarDate = calendar.date(byAdding: DateComponents(month: -1), to: nowCalendarDate) ?? Date()
        updateCurrentMonthDays()
        
        return getYearMonthText()
    }
    
    // 다음 달로
    func plusMonth() -> String {
        nowCalendarDate = calendar.date(byAdding: DateComponents(month: 1), to: nowCalendarDate) ?? Date()
        updateCurrentMonthDays()
        
        return getYearMonthText()
    }
    
    // 달 이동 
    func moveMonth(month: Int) -> String {
        let addMonth = month - Int(currentMonth())!
        nowCalendarDate = calendar.date(byAdding: DateComponents(month: addMonth), to: nowCalendarDate) ?? Date()
        updateCurrentMonthDays()
        
        return getYearMonthText()
    }
    
    func moveDate(year: Int, month: Int) -> String {
        let addYear = year - Int(currentYear())!
        let addMonth = month - Int(currentMonth())!
        
        nowCalendarDate = calendar.date(byAdding: DateComponents(year: addYear, month: addMonth), to: nowCalendarDate) ?? Date()
        updateCurrentMonthDays()
        
        return getYearMonthText()
    }
    
    // 현재 보여주는 달력의 month
    func currentMonth() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        
        return formatter.string(from: nowCalendarDate)
    }
        
    func currentYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        return formatter.string(from: nowCalendarDate)
    }
}

private extension CalendarDateFormatter {
    // 해당 달의 1일 요일 반환
    func getStartingDayOfWeek() -> Int {
        return calendar.component(.weekday, from: nowCalendarDate) - 1
    }
    
    // 해당 달의 날짜가 며칠까지 있는지 반환
    func getEndDateOfMonth() -> Int {
        return calendar.range(of: .day, in: .month, for: nowCalendarDate)?.count ?? 0
    }
    
    func configureCalendar() {
        let components = calendar.dateComponents([.year, .month], from: Date())
        nowCalendarDate = calendar.date(from: components) ?? Date()
        dateFormatter.dateFormat = "yyyy년 MM월"
    }
}
