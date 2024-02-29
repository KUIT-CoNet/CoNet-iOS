//
//  MeetingMainAPI.swift
//  CoNet
//
//  Created by 가은 on 2023/08/06.
//

import Alamofire
import Foundation
import KeychainSwift

class MeetingMainAPI {
    let baseUrl = "https://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"
    let keychain = KeychainSwift()

    // 팀 내 특정 달 약속 조회
    func getMeetingMonthPlan(teamId: Int, searchDate: String, completion: @escaping (_ count: Int, _ dates: [Int]) -> Void) {
        
        let url = "\(baseUrl)/plan/month?teamId=\(teamId)&searchDate=\(searchDate)"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]

        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: BaseResponse<GetMonthPlanResult>.self) { response in
                switch response.result {
                case .success(let response):
                    guard let result = response.result else { return }
                    print("DEBUG(get meeting month plan api): \(result)")
                    completion(result.count, result.dates)

                case .failure(let error):
                    print("DEBUG(get meeting month plan api) error: \(error)")
                }
            }
    }
    
    // 팀 내 특정 날짜 약속 조회
    func getMeetingDayPlan(teamId: Int, searchDate: String, completion: @escaping (_ count: Int, _ plans: [MeetingDayPlan]) -> Void) {
        let url = "\(baseUrl)/team/plan/day?teamId=\(teamId)&searchDate=\(searchDate)"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]

        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: BaseResponse<GetMeetingDayPlanResult>.self) { response in
                switch response.result {
                case .success(let response):
                    guard let result = response.result else { return }
                    print("DEBUG(get meeting day plan api): \(result)")
                    completion(result.count, result.plans)

                case .failure(let error):
                    print("DEBUG(get meeting day plan api) error: \(error)")
                }
            }
    }

}
