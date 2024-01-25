//
//  TimeAPI.swift
//  CoNet
//
//  Created by 가은 on 2023/08/07.
//

import Alamofire
import Foundation
import KeychainSwift

class PlanTimeAPI {
    let baseUrl = "http://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"
    let keychain = KeychainSwift()
    
    // 구성원의 가능한 시간 조회
    func getMemberPossibleTime(planId: Int, completion: @escaping (_ teamId: Int, _ planId: Int, _ planName: String, _ planStartPeriod: String, _ planEndPeriod: String, _ sectionMemberCounts: [SectionMemberCounts], _ possibleMemberDateTime: [PossibleMemberDateTime]) -> Void) {
        let url = "\(baseUrl)/team/plan/member-time?planId=\(planId)"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]

        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: BaseResponse<GetMemberPossibleTimeResult>.self) { response in
                switch response.result {
                case .success(let response):
                    guard let result = response.result else { return }
                    completion(result.teamId, result.planId, result.planName, result.planStartPeriod, result.planEndPeriod, result.sectionMemberCounts, result.possibleMemberDateTime)

                case .failure(let error):
                    print("DEBUG(getMemberPossibleTime api) error: \(error)")
                }
            }
    }
    
    // 나의 가능한 시간 조회
    func getMyPossibleTime(planId: Int, completion: @escaping (_ planId: Int, _ userId: Int, _ hasRegisteredTime: Bool, _ hasPossibleTime: Bool, _ possibleTime: [PossibleTime]) -> Void) {
        let url = "\(baseUrl)/team/plan/user-time?planId=\(planId)"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]

        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: BaseResponse<GetMyPossibleTimeResult>.self) { response in
                switch response.result {
                case .success(let response):
                    guard let result = response.result else { return }
                    print("DEBUG(getMyPossibleTime api): \(result)")
                    
                    completion(result.planId, result.userId, result.hasRegisteredTime, result.hasPossibleTime, result.possibleTime)

                case .failure(let error):
                    print("DEBUG(getMyPossibleTime api) error: \(error)")
                }
            }
    }
    
    // 나의 가능한 시간 저장
    func postMyPossibleTime(planId: Int, possibleDateTimes: [PossibleTime]) {
        let url = "\(baseUrl)/team/plan/time"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        var times: [[String: Any]] = []
        for time in possibleDateTimes {
            let data = ["date": time.date, "time": time.time] as [String: Any]
            times.append(data)
        }

        let body: [String: Any] = [
            "planId": planId,
            "possibleDateTimes": times
        ]
        
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: BaseResponse<String>.self) { response in
                switch response.result {
                case .success(let response):
                    guard let result = response.result else { return }
                    print("DEBUG(postMyPossibleTime api): \(result)")
                    
                case .failure(let error):
                    print("DEBUG(postMyPossibleTime api) error: \(error)")
                }
            }
    }
}
