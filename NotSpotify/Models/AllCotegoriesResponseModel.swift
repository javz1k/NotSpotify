//
//  AllCotegoriesResponseModel.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 18.05.24.
//

import Foundation
struct AllCotegoriesResponseModel: Codable {
    let categories:Categories
}
struct Categories: Codable {
    let items: [Category]
}

struct Category: Codable {
    let id: String
    let name: String
    let icons:[APIImageModel]
}
