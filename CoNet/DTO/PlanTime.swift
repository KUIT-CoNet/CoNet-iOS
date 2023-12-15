//
//  PlanTime.swift
//  CoNet
//
//  Created by 가은 on 2023/08/07.
//

import Foundation

// 구성원의 가능한 시간 조회
struct GetMemberPossibleTimeResult: Codable {
    let teamId, planId: Int
    let planName, planStartPeriod, planEndPeriod: String
    let sectionMemberCounts: [SectionMemberCounts]
    let possibleMemberDateTime: [PossibleMemberDateTime]
}

struct SectionMemberCounts: Codable {
    let section: Int
    let memberCount: [Int]
}

struct PossibleMemberDateTime: Codable {
    let date: String
    let possibleMember: [PossibleMember]
}

struct PossibleMember: Codable {
    let time: Int
    let section: Int
    let memberNames: [String]
    let memberIds: [Int]
}

// 나의 가능한 시간 조회
struct GetMyPossibleTimeResult: Codable {
    let planId, userId: Int
    let hasRegisteredTime: Bool     // 시간 입력한 적이 있는가에 대한 값
    let hasPossibleTime: Bool       // 가능한 시간이 있는가에 대한 값 -> 시간 없음 버튼을 클릭하면 false 값
    var possibleTime: [PossibleTime]
}

struct PossibleTime: Codable {
    var date: String
    var time: [Int]
}
