//
//  CharacterDetailModel.swift
//  RickAndMortyApp
//
//  Created by Олег Романов on 18.07.2024.
//

import Foundation

// MARK: - EpisodesResponseElement

struct EpisodesResponseElement: Codable {
    let id: Int
    let name : String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case airDate = "air_date"
        case episode
        case characters
        case url
        case created
    }
}

// MARK: - EpisodesResponse

typealias EpisodesResponse = [EpisodesResponseElement]
