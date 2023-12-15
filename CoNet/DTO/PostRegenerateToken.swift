//
//  PostRegenerateToken.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/05.
//

import Foundation

struct PostRegenerateTokenResponse: Codable {
    let code, status: Int
    let message: String
    let result: PostRegenerateTokenResult
}

struct PostRegenerateTokenResult: Codable {
    let email, accessToken, refreshToken, isRegistered: String
}
