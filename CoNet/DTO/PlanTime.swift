//
//  PlanTime.swift
//  CoNet
//
//  Created by 가은 on 2023/08/07.
//

import Foundation

// 구성원의 가능한 시간 조회
struct GetMemberPossibleTimeResponse: Codable {
    let teamId, planId: Int
    let planName, planStartPeriod, planEndPeriod: String
    let endNumberForEachSection: SectionMemberCounts
    let availableMemberDateTime: [PossibleMemberDateTime]
}

struct SectionMemberCounts: Codable {
    let section1: Int
    let section2: Int
    let section3: Int
}

struct PossibleMemberDateTime: Codable {
    let date: String
    let sectionAndAvailableTimes: [PossibleMember]
}

struct PossibleMember: Codable {
    let time: Int
    let section: Int
    let memberNames: [String]
    let memberIds: [Int]
}

// 나의 가능한 시간 조회
struct GetMyPossibleTimeResponse: Codable {
    let planId, memberId: Int
    let availableTimeRegisteredStatus: Int
    var timeSlot: [PossibleTime]
}

struct PossibleTime: Codable {
    var date: String
    var availableTimes: [Int]
}
