// File: House.swift Project: Thrones
// Created by: Prof. John Gallaugher on 11/10/24
// YouTube.com/profgallaugher  -  threads.net/john.gallaugher

import Foundation

struct House: Codable, Identifiable {
    let id = UUID().uuidString
    var name: String
    var url: String
    var words: String
    
    enum CodingKeys: CodingKey {
        case name, url, words
    }
}
