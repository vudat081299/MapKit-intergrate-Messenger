//
//  Token.swift
//  MyMapKit
//
//  Created by Vũ Quý Đạt  on 24/12/2020.
//

import Foundation

final class Token: Codable {
    var code: Int
    var message: String
    var data: TokenData
    
    init(code: Int, message: String, data: TokenData) {
        self.code = code
        self.message = message
        self.data = data
    }
}

struct TokenData: Codable {
    let id: UUID?
    let token: String
    let userID: UUID
}
