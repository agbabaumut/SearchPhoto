//
//  Model.swift
//  SearchPhoto
//
//  Created by Umut Ağbaba on 21.04.2023.
//

import Foundation

struct APIResponse: Codable {
    let total: Int
    let total_pages: Int
    let results: [Result]
}

struct Result: Codable {
    let id: String
    let urls: URLs
}

struct URLs: Codable {
    let regular: String
}
