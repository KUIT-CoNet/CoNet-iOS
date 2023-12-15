//
//  HistoryAPI.swift
//  CoNet
//
//  Created by 이안진 on 2023/08/06.
//

import Alamofire
import Foundation
import KeychainSwift
import UIKit

struct GetHistoryResult: Codable {
    let planId: Int
    let planName, planDate: String
    let planMemberNum: Int
    let historyImgUrl, historyDescription: String?
}

struct PostHistoryResult: Codable {
    let historyId: Int
}

class HistoryAPI {
    let keychain = KeychainSwift()
    let baseUrl = "http://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"
    
    // 히스토리 조회
    func getHistory(meetingId: Int, completion: @escaping (_ histories: [GetHistoryResult]) -> Void) {
        let url = "\(baseUrl)/history?teamId=\(meetingId)"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: BaseResponse<[GetHistoryResult]>.self) { response in
                switch response.result {
                case .success(let response):
                    guard let serverHistories = response.result else { return }
                    completion(serverHistories)
                    
                case .failure(let error):
                    print("DEBUG(히스토리 조회 api) error: \(error)")
                }
            }
    }
    
    // 히스토리 생성
    func postHistory(planId: Int, image: UIImage, description: String, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let url = "\(baseUrl)/history/register"
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data"
        ]
        let request = "{\"planId\":\(planId), \"description\": \"\(description)\"}"
        guard let image = image.pngData() else { return }
        
        // Multipart Form 데이터 생성
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(image, withName: "file", fileName: "\(image).png", mimeType: "image/png")
            multipartFormData.append(request.data(using: .utf8)!, withName: "registerRequest", mimeType: "application/json")
        }, to: url, method: .post, headers: headers)
        .responseDecodable(of: BaseResponse<PostHistoryResult>.self) { response in
            switch response.result {
            case .success(let response):
                print("DEBUG(히스토리 생성 api) success response: \(response)")
                completion(response.code == 1000)
                
            case .failure(let error):
                print("DEBUG(히스토리 생성 api) error: \(error)")
            }
        }
    }
}
