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
    let planName: String
    let participant: Bool
    let dday: Int
}

struct PlanDetail: Codable {
    let planId: Int
    let planName, date, time: String
    let memberCount: Int
    let members: [PlanDetailMember]
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

struct Result: Codable {
    let planID: Int

    enum CodingKeys: String, CodingKey {
        case planID = "planId"
    }
}

struct FixedPlanResponse: Codable {
    let planName, fixedDate, fixedTime: String
    let memberCount: Int
}
