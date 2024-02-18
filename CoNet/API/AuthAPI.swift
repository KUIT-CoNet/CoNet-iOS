//
//  AuthApi.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/05.
//

import Alamofire
import Foundation
import KeychainSwift

class AuthAPI {
    let keychain = KeychainSwift()
    let baseUrl = "http://\(Bundle.main.infoDictionary?["BASE_URL"] ?? "nil baseUrl")"
    static let shared = AuthAPI()
    
    func regenerateToken(completion: @escaping (_ isSuccess: Bool) -> Void) {
        let url = "\(baseUrl)/auth/regenerate-token"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(keychain.get("refreshToken") ?? "")"
        ]
        let body: [String: Any] = [:]
        print("Bearer \(keychain.get("refreshToken") ?? "")")
        
        AF.request(url,
                   method: .post,
                   parameters: body,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .responseData { response in
                switch response.result {
                case .success:
                    let decoder = JSONDecoder()
                    guard let statusCode = response.response?.statusCode else { return }
                    guard let data = response.value else { return }

                    switch statusCode {
                    case 200:
                        guard let data = try? decoder.decode(PostRegenerateTokenResponse.self, from: data) else { return }

                        self.keychain.set(data.result.accessToken, forKey: "accessToken")
                        self.keychain.set(data.result.refreshToken, forKey: "refreshToken")

                        completion(true)

                    default:
                        guard let data = try? decoder.decode(BadRequestResponse.self, from: data) else { return }
                        print("DEBUG 모임 참여 api message: \(data.message)")
                        completion(false)

                    }
                case .failure(let error):
                    print("DEBUG regenerate api: \(error)")
                    completion(false)
                }
            }
    }
    
    // login
    // platform: apple or kakao
    func login(platform: String, completion: @escaping (_ isRegistered: Bool) -> Void) {
        // 통신할 API 주소
        let url = "\(baseUrl)/auth/login"
        
        // HTTP Headers : 요청 헤더
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        // request body
        let body: [String: Any] = [
            "platform": platform,
            "idToken": keychain.get("idToken") ?? ""
        ]
        
        // Request 생성
        let dataRequest = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
        
        // responseData를 호출하면서 데이터 통신 시작
        // response에 데이터 통신의 결과가 담깁니다.
        dataRequest.responseDecodable(of: BaseResponse<LoginResponse>.self) { response in
            switch response.result {
            case .success(let response):  // 성공한 경우에
                print(response.result ?? "result empty")
                
                // 사용자 정보 저장
                self.keychain.set(response.result!.email, forKey: "email")
                self.keychain.set(response.result!.accessToken, forKey: "accessToken")
                self.keychain.set(response.result!.refreshToken, forKey: "refreshToken")
                completion(response.result!.isRegistered)
                
            case .failure(let error):
                print("DEBUG(login api) error: \(error)")
            }
        }
    }
    
    // signUp - 약관 동의, 이름 입력
    func signUp(name: String, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let url = "\(baseUrl)/auth/term"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(keychain.get("accessToken") ?? "")"
        ]
        let body: [String: Any] = [
            "name": name
        ]
        
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: BaseResponse<SignUpResponse>.self) { response in
            switch response.result {
            case .success(let response):  // 성공한 경우에
                // 회원가입 성공 Bool 반환
                completion(response.code == 1000)
                
            case .failure(let error):
                print("DEBUG(sign up api) error: \(error)")
            }
        }
    }
}
