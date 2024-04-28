//
//  AuthResponseModel.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 27.04.24.
//

import Foundation

struct AuthResponseModel: Codable {
    let access_token: String?
    let expires_in: Int?
    let refresh_token: String?
    let scope:String?
    let token_type: String?
}

