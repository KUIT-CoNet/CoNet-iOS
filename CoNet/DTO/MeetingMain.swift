//
//  MeetingMain.swift
//  CoNet
//
//  Created by 가은 on 2023/08/06.
//

import Foundation

// 팀 내 특정 날짜 약속 조회
struct GetMeetingDayPlanResult: Codable {
    let count: Int
    let plans: [MeetingDayPlan]
}

struct MeetingDayPlan: Codable {
    let planId: Int
    let date: String?
    let time: String
    let teamName: String?
    let planName: String
}

struct MeetingWaitingPlan: Codable {
    let planId: Int
    let startDate: String
    let endDate: String
    let teamName: String?
    let planName: String
}
