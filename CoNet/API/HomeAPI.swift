//
//  HomeAPI.swift
//  CoNet
//
//  Created by 가은 on 2023/07/25.
//

import Alamofire
import Foundation
import KeychainSwift

class HomeAPI {
    let baseUrl = "http://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"
    static let shared = HomeAPI()
    
    // 특정 달 약속 조회
    func getMonthPlan(date: String, completion: @escaping (_ count: Int, _ dates: [Int]) -> Void) {
        
        let query = URLQueryItem(name: "searchDate", value: date)
        
        // 통신할 API 주소
        let url = "\(baseUrl)/home/month?\(query)"
        
        // HTTP Headers : 요청 헤더
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        // Request 생성
        // get 인 경우 JSONEncoding 에러 뜨면 URLEncoding으로 변경
        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
        
        // responseData를 호출하면서 데이터 통신 시작
        // response에 데이터 통신의 결과가 담깁니다.
        dataRequest.responseDecodable(of: BaseResponse<GetMonthPlanResult>.self) { response in
            switch response.result {
            case .success(let response): // 성공한 경우에
                guard let result = response.result else { return }
                
                let count = result.count
                let dates = result.dates
                
                completion(count, dates)
                
            case .failure(let error):
                print("DEBUG(getmonthplan api) error: \(error)")
            }
        }
    }
    
    // 특정 날짜의 약속 조회
    func getDayPlan(date: String, completion: @escaping (_ count: Int, _ plans: [Plan]) -> Void) {
        
        let query = URLQueryItem(name: "searchDate", value: date)
        
        // 통신할 API 주소
        let url = "\(baseUrl)/home/day?\(query)"
        
        // HTTP Headers : 요청 헤더
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        // Request 생성
        // get 인 경우 JSONEncoding 에러 뜨면 URLEncoding으로 변경
        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
        
        // responseData를 호출하면서 데이터 통신 시작
        // response에 데이터 통신의 결과가 담깁니다.
        dataRequest.responseDecodable(of: BaseResponse<GetDayPlanResult>.self) { response in
            switch response.result {
            case .success(let response): // 성공한 경우에
                guard let result = response.result else { return }
                
                let count = result.count
                let plans = result.plans
                
                completion(count, plans)
                
            case .failure(let error):
                print("DEBUG(getdayplan api) error: \(error)")
            }
        }
    }
    
    // 대기 중인 약속 조회
    func getWaitingPlan(completion: @escaping (_ count: Int, _ plans: [WaitingPlan]) -> Void) {
        
        // 통신할 API 주소
        let url = "\(baseUrl)/home/waiting"
        
        // HTTP Headers : 요청 헤더
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        // Request 생성
        // get 인 경우 JSONEncoding 에러 뜨면 URLEncoding으로 변경
        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
        
        // responseData를 호출하면서 데이터 통신 시작
        // response에 데이터 통신의 결과가 담깁니다.
        dataRequest.responseDecodable(of: BaseResponse<GetWaitingPlanResult>.self) { response in
            switch response.result {
            case .success(let response): // 성공한 경우에
                guard let result = response.result else { return }
                
                let count = result.count
                let plans = result.plans
                
                completion(count, plans)
                
            case .failure(let error):
                print("DEBUG(getwaitingplan api) error: \(error)")
            }
        }
    }
}
