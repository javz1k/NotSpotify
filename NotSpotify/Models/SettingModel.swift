//
//  SettingModel.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 03.05.24.
//

import Foundation

struct Section {
    let title:String
    let options:[Option]
}

struct Option {
    let title:String
    let handler : (()-> Void)
}
