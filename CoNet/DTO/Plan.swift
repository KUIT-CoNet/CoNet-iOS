//
//  Plan.swift
//  CoNet
//
//  Created by 가은 on 2/27/24.
//

import Foundation

struct GetPlansAtMeetingResult<T: Codable>: Codable {
    let count: Int
    let plans: T?
}

struct CreatePlanResponse: Codable {
    let planId: Int
}

struct WaitingPlanInfo: Codable {
    let planId: Int
    let startDate, endDate, planName: String
    let teamName: String?
}

struct DecidedPlanInfo: Codable {
    let planId: Int
    let date, time: String
    let teamName: String?
    let planName: String
    let dday: Int
}

struct PastPlanInfo: Codable {
    let planId: Int
    let date, time, planName: String
    let isRegisteredToHistory: Bool
}

struct PlanDetail: Codable {
    let planId: Int
    let planName, date, time: String
    let members: [PlanDetailMember]
    let isRegisteredToHistory: Bool
    let historyImgUrl, historyDescription: String?
}

struct PlanDetailMember: Codable {
    let id: Int
    let name, image: String
}

struct EditPlanMember: Codable {
    let id: Int
    let name, image: String
    let isAvailable: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id = "userId"
        case name = "name"
        case image = "userImgUrl"
        case isAvailable = "isInPlan"
    }
}

struct PlanEditResponse: Codable {
    let code, status: Int
    let message, result: String
}

struct Result: Codable {
    let planID: Int

    enum CodingKeys: String, CodingKey {
        case planID = "planId"
    }
}