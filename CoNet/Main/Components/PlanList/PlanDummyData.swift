//
//  PlanDummyData.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/23.
//

import Foundation

struct WaitingPlan2 {
    let startDate: String
    let finishDate: String
    let title: String
}

struct DecidedPlan {
    let date: String
    let time: String
    let title: String
    let leftDate: String
}

struct PastPlan {
    let date: String
    let time: String
    let title: String
    let isExistHistory: Bool
}

struct DayPlan {
    let time: String
    let planTitle: String
    let groupName: String
}

struct PlanDummyData {
    static let watingPlanData: [WaitingPlan2] = [
        WaitingPlan2(startDate: "2023. 07. 02", finishDate: "2023. 07. 08", title: "iOS 스터디 1차"),
        WaitingPlan2(startDate: "2023. 07. 11", finishDate: "2023. 07. 15", title: "Android 스터디 2차"),
        WaitingPlan2(startDate: "2023. 07. 13", finishDate: "2023. 07. 19", title: "Server 스터디 3차"),
        WaitingPlan2(startDate: "2023. 07. 13", finishDate: "2023. 07. 19", title: "iOS 스터디 3차"),
        WaitingPlan2(startDate: "2023. 07. 13", finishDate: "2023. 07. 19", title: "iOS 스터디 3차인데 여러 줄이면 어떻게 되나"),
        WaitingPlan2(startDate: "2023. 07. 13", finishDate: "2023. 07. 19", title: "iOS 스터디 3차"),
        WaitingPlan2(startDate: "2023. 07. 13", finishDate: "2023. 07. 19", title: "iOS 스터디 3차"),
        WaitingPlan2(startDate: "2023. 07. 13", finishDate: "2023. 07. 19", title: "iOS 스터디 3차"),
        WaitingPlan2(startDate: "2023. 07. 13", finishDate: "2023. 07. 19", title: "iOS 스터디 3차"),
        WaitingPlan2(startDate: "2023. 07. 13", finishDate: "2023. 07. 19", title: "iOS 스터디 3차"),
        WaitingPlan2(startDate: "2023. 07. 13", finishDate: "2023. 07. 19", title: "iOS 스터디 3차"),
        WaitingPlan2(startDate: "2023. 07. 13", finishDate: "2023. 07. 19", title: "iOS 스터디 3차")]
    
    static let decidedPlanData: [DecidedPlan] = [
        DecidedPlan(date: "2023. 07. 08", time: "14:00", title: "iOS 1차 스터디", leftDate: "3일 남았습니다."),
        DecidedPlan(date: "2023. 07. 11", time: "16:00", title: "Android 2차 스터디입니다요 우하하", leftDate: "6일 남았습니다."),
        DecidedPlan(date: "2023. 07. 12", time: "15:00", title: "Server 3차 스터디입니다요 우하하흐하", leftDate: "7일 남았습니다."),
        DecidedPlan(date: "2023. 07. 12", time: "15:00", title: "Server 3차 스터디입니다요 우하하흐하", leftDate: "7일 남았습니다."),
        DecidedPlan(date: "2023. 07. 12", time: "15:00", title: "Server 3차 스터디입니다요 우하하흐하", leftDate: "7일 남았습니다."),
        DecidedPlan(date: "2023. 07. 12", time: "15:00", title: "Server 3차 스터디입니다요 우하하흐하", leftDate: "7일 남았습니다."),
        DecidedPlan(date: "2023. 07. 12", time: "15:00", title: "Server 3차 스터디입니다요 우하하흐하", leftDate: "7일 남았습니다."),
        DecidedPlan(date: "2023. 07. 12", time: "15:00", title: "Server 3차 스터디입니다요 우하하흐하", leftDate: "7일 남았습니다."),
        DecidedPlan(date: "2023. 07. 12", time: "15:00", title: "Server 3차 스터디입니다요 우하하흐하", leftDate: "7일 남았습니다."),
        DecidedPlan(date: "2023. 07. 12", time: "15:00", title: "Server 3차 스터디입니다요 우하하흐하", leftDate: "7일 남았습니다."),
        DecidedPlan(date: "2023. 07. 12", time: "15:00", title: "Server 3차 스터디입니다요 우하하흐하", leftDate: "7일 남았습니다.")]
    
    static let pastPlanData: [PastPlan] = [
        PastPlan(date: "2023. 07. 08", time: "14:00", title: "iOS 1차 스터디", isExistHistory: true),
        PastPlan(date: "2023. 07. 09", time: "16:00", title: "Android 2차 스터디", isExistHistory: false),
        PastPlan(date: "2023. 07. 13", time: "21:00", title: "Server 3차 스터디", isExistHistory: true),
        PastPlan(date: "2023. 07. 13", time: "21:00", title: "Server 3차 스터디", isExistHistory: true),
        PastPlan(date: "2023. 07. 13", time: "21:00", title: "Server 3차 스터디", isExistHistory: false),
        PastPlan(date: "2023. 07. 13", time: "21:00", title: "Server 3차 스터디", isExistHistory: true),
        PastPlan(date: "2023. 07. 13", time: "21:00", title: "Server 3차 스터디", isExistHistory: true),
        PastPlan(date: "2023. 07. 13", time: "21:00", title: "Server 3차 스터디", isExistHistory: true),
        PastPlan(date: "2023. 07. 13", time: "21:00", title: "Server 3차 스터디", isExistHistory: false),
        PastPlan(date: "2023. 07. 13", time: "21:00", title: "Server 3차 스터디", isExistHistory: false),
        PastPlan(date: "2023. 07. 13", time: "21:00", title: "Server 3차 스터디", isExistHistory: true),
        PastPlan(date: "2023. 07. 13", time: "21:00", title: "Server 3차 스터디", isExistHistory: false),
        PastPlan(date: "2023. 07. 13", time: "21:00", title: "Server 3차 스터디", isExistHistory: true),
        PastPlan(date: "2023. 07. 13", time: "21:00", title: "Server 3차 스터디", isExistHistory: true)]
    
    static let dayPlanData: [DayPlan] = [
        DayPlan(time: "14:00", planTitle: "iOS 1차 스터디", groupName: "iOS 스터디"),
        DayPlan(time: "15:00", planTitle: "iOS 2차 스터디", groupName: "iOS 스터디")
    ]
    
}
