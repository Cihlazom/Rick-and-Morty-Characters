//
//  Requests.swift
//  Rick and Morty Library
//
//  Created by Vladislav on 14.04.2022.
//

import Foundation

//main request
struct MainRequest: Codable {
    var results: [MainInfo] = []
    var info: Info = Info()
}

struct Info: Codable {
    var next: URL? = nil
}

struct MainInfo: Codable {
    let id: Int
    let name: String
    let species: String
    let gender: String
    let image: URL
}

//character request

struct CharacterInfo: Codable {
    let name: String
    let status: String
    let species: String
    let gender: String
    let image: URL
    let episode: [String]
    let location: Location
}

struct Location: Codable {
    let name: String
}
