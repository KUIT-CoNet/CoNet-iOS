//
//  Login.swift
//  CoNet
//
//  Created by 가은 on 2023/07/13.
//

import Foundation

struct LoginResponse: Codable {
    let email: String
    let accessToken: String
    let refreshToken: String
    let isRegistered: Bool
}

// 회원가입 sign up
struct SignUpResponse: Codable {
    let name: String
    let email: String
    let serviceTerm: Bool
}
