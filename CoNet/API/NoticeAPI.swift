//
//  NoticeAPI.swift
//  CoNet
//
//  Created by 정아현 on 3/2/24.
//

import Alamofire
import Foundation
import KeychainSwift
import UIKit

struct NoticeResponse: Codable {
    let title: String
    let content: String
    let date: String
}

struct NoticesResult: Codable {
    let notices: [NoticeResponse]
}

class NoticeAPI {
    let keychain = KeychainSwift()
    let baseUrl = "https://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"

    func getNotice(completion: @escaping (_ notices: [NoticeResponse]?) -> Void) {
        let url = "\(baseUrl)/notice"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json", 
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        
        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: BaseResponse<NoticesResult>.self) { response in
                switch response.result {
                case .success(let response):
                    guard let result = response.result else { return }
                    
                    let notices = result.notices
                    completion(notices)
                case .failure(let error):
                    print("DEBUG(getnotice api) error: \(error)")
                }
            }
    }
}
