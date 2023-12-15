//
//  BaseResponse.swift
//  CoNet
//
//  Created by 가은 on 2023/07/12.
//

import Foundation

class BaseResponse<T: Codable>: Codable {
    let code, status: Int
    let message: String
    let result: T?
}
