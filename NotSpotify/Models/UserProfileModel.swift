//
//  UserProfileModel.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 25.04.24.
//

import Foundation

struct UserProfileModel: Codable {
    let country: String
    let display_name: String
    let email:String
    let explicit_content: [String: Bool]
    let external_urls: [String: String]
//    let followers:[String: Codable?] not codable
    let id:String
    let product:String
    let images: [APIImageModel]
}


