//
//  Meeting.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/31.
//

import Foundation

struct PostMeetingInviteCodeResponse: Codable {
    let teamId: Int
    let inviteCode, codeDeadLine: String
}

struct PostParticipateMeetingResponse: Codable {
    let userName, teamName: String
    let status: Bool
}

struct GetMeetingDetailInfoResponse: Codable {
    let teamId: Int
    let teamName, teamImgUrl: String
    let teamMemberCount: Int
    let isNew: Bool?
    let bookmark: Bool
}

struct MeetingSimpleInfo {
    let name, imgUrl: String
    let memberCount: Int
    let bookmark: Bool
}

struct GetMeetingResponse: Codable {
    let teamId: Int
    let teamName, teamImgUrl: String
    let teamMemberCount: Int
    let isNew, bookmark: Bool
}

struct MeetingDetailInfo {
    let id: Int
    let name, imgUrl: String
    let memberCount: Int
    let isNew, bookmark: Bool
}

struct PostCreateMeetingResponse: Codable {
    let teamId: Int
    let inviteCode: String
}

struct TeamMember: Codable {
    let userId: Int
    let name: String
    let userImgUrl: String
}
