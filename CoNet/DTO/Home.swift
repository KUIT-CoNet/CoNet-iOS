//
//  Home.swift
//  CoNet
//
//  Created by 가은 on 2023/07/25.
//

import Foundation

// 특정 달 약속 조회
struct GetMonthPlanResult: Codable {
    let count: Int
    let dates: [Int]
}

// 특정 날짜 약속 조회
struct GetDayPlanResult: Codable {
    let count: Int
    let plans: [Plan]
}

// 대기 중인 약속 조회
struct GetWaitingPlanResponse: Codable {
    let count: Int
    let plans: [WaitingPlan]
}

struct Plan: Codable {
    let planId: Int
    let time, teamName, planName: String
}

struct WaitingPlan: Codable {
    let planId: Int
    let startDate, endDate, teamName, planName: String
}
