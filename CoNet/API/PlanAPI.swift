//
//  PlanAPI.swift
//  CoNet
//
//  Created by 이안진 on 2023/08/05.
//

import Alamofire
import Foundation
import KeychainSwift
import UIKit

class PlanAPI {
    let keychain = KeychainSwift()
    let baseUrl = "https://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"
    
    // 팀 내 대기중인 약속 조회
    func getWaitingPlansAtMeeting(meetingId: Int, completion: @escaping (_ count: Int, _ plans: [WaitingPlanInfo]) -> Void) {
        let url = "\(baseUrl)/plan/waiting?teamId=\(meetingId)"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: BaseResponse<GetPlansAtMeetingResult<[WaitingPlanInfo]>>.self) { response in
                switch response.result {
                case .success(let response):
                    guard let count = response.result?.count else { return }
                    guard let serverPlans = response.result?.plans else { return }
                    completion(count, serverPlans)
                    
                case .failure(let error):
                    print("DEBUG(팀 내 대기 중인 약속 api) error: \(error)")
                }
            }
    }
    
    // 팀 내 확정된 지난/다가오는 약속 조회
    func getDecidedPlansAtMeeting(meetingId: Int, period: String, status: Bool, completion: @escaping (_ count: Int, _ plans: [DecidedPlanInfo]) -> Void) {
        let url = "\(baseUrl)/plan/fixed?teamId=\(meetingId)&period=\(period)"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: BaseResponse<GetPlansAtMeetingResult<[DecidedPlanInfo]>>.self) { response in
                switch response.result {
                case .success(let response):
                    guard let count = response.result?.count else { return }
                    guard let serverPlans = response.result?.plans else { return }
                    
                    if !status {
                        completion(count, serverPlans)
                        return
                    }
                    
                    var myPlans: [DecidedPlanInfo] = []
                    for plan in serverPlans {
                        if plan.participant {
                            let myPlan = DecidedPlanInfo(planId: plan.planId, date: plan.date, time: plan.time, planName: plan.planName, participant: plan.participant, dday: plan.dday)
                            myPlans.append(myPlan)
                        }
                    }
                    
                    completion(count, myPlans)
                    
                case .failure(let error):
                    print("DEBUG(팀 내 확정된 지난/다가오는 약속 api) error: \(error)")
                }
            }
    }
    
    // 약속 상세 정보 조회
    func getPlanDetail(planId: Int, completion: @escaping (_ plans: PlanDetail) -> Void) {
        let url = "\(baseUrl)/plan/\(planId)"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: BaseResponse<PlanDetail>.self) { response in
                switch response.result {
                case .success(let response):
                    guard let serverPlans = response.result else { return }
                    print(serverPlans)
                    completion(serverPlans)
                case .failure(let error):
                    print("DEBUG(약속 상세 정보 조회 api) error: \(error)")
                }
        }
    }
    
    // 약속 상세 수정
    func updatePlan(planId: Int, planName: String, date: String?, time: String, members: [Int]?, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let url = "\(baseUrl)/plan/update/fixed"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        let requestBody: [String: Any] = [
            "planId": planId,
            "planName": planName,
            "time": time,
            "date": date ?? "",
            "memberIds": members ?? []
        ]
        
        AF.request(url, method: .post, parameters: requestBody, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: BaseResponse<String>.self) { response in
                switch response.result {
                case .success(let response):
                    print("DEBUG(약속 상세 수정 api) success response: \(response.message)")
                    completion(response.code == 1000)
                    
                case .failure(let error):
                    print("DEBUG(약속 상세 수정 api) error: \(error)")
                }
            }
    }
    
    // 약속 생성
    func createPlan(teamId: Int, planName: String, planStartDate: String, completion: @escaping (_ planId: Int, _ isSuccess: Bool) -> Void) {
        let url = "\(baseUrl)/plan"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        let parameters: Parameters = [
            "teamId": teamId,
            "planName": planName,
            "planStartDate": planStartDate
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        .responseDecodable(of: BaseResponse<CreatePlanResponse>.self) { response in
            switch response.result {
            case .success(let response):
                print("DEBUG(약속 생성 api) success response: \(response.message)")
                guard let planId = response.result?.planId else { return }
                completion(planId, response.code == 1000)
                
            case .failure(let error):
                print("DEBUG(create plan api) error: \(error)")
            }
        }
    }

    // 약속 삭제
    func deletePlan(planId: Int, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let url = "\(baseUrl)/plan/\(planId)"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: headers)
        .responseDecodable(of: BaseResponse<String>.self) { response in
            switch response.result {
            case .success(let response):
                print("DEBUG(약속 삭제 api) success response: \(response.message)")
                completion(response.code == 1000)
                
            case .failure(let error):
                print("DEBUG(약속 삭제 api) error: \(error)")
            }
        }
    }
    
    // 약속 확정
    func fixPlan(planId: Int, fixedDate: String, fixedTime: Int, userId: [Int], completion: @escaping (_ fixedPlan: FixedPlanResponse) -> Void) {
        let url = "\(baseUrl)/plan/fix"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        let parameters: Parameters = [
            "planId": planId,
            "fixedDate": fixedDate,
            "fixedTime": fixedTime,
            "memberIds": userId
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        .responseDecodable(of: BaseResponse<FixedPlanResponse>.self) { response in
            switch response.result {
            case .success(let response):
                print("DEBUG(약속 확정 api) success response: \(response.message)")
                guard let result = response.result else { return }
                
                completion(result)
                
            case .failure(let error):
                print("DEBUG(약속 확정 api) error: \(error)")
            }
        }
    }
    
    // 대기 중 약속 수정
    func editWaitingPlan(planId: Int, planName: String, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let url = "\(baseUrl)/plan/update/waiting"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        let parameters: Parameters = [
            "planId": planId,
            "planName": planName
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        .responseDecodable(of: BaseResponse<String>.self) { response in
            switch response.result {
            case .success(let response):
                print("DEBUG(약속 수정 api) success response: \(response.result ?? "empty")")
                
                completion(response.code == 1000)
            case .failure(let error):
                print("DEBUG(약속 수정 api) error: \(error)")
            }
        }
    }
    
    // 구성원 약속 가능 여부 조회
    func getPlanMemberIsAvailable(planId: Int, completion: @escaping (_ members: [EditPlanMember]) -> Void) {
        let url = "\(baseUrl)/team/plan/member-plan?planId=\(planId)"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: BaseResponse<[EditPlanMember]>.self) { response in
                switch response.result {
                case .success(let response):
                    guard let result = response.result else { return }
                    print("구성원 가능 여부 조회 \(response.message)")
                    completion(result)
                    
                case .failure(let error):
                    print("구성원 가능 여부 조회 \(error)")
                }
        }
    }
}
    
