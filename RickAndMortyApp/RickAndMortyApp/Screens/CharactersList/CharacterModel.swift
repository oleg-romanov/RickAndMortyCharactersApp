//
//  CharacterResponse.swift
//  RickAndMortyApp
//
//  Created by Олег Романов on 17.07.2024.
//

import Foundation
import SwiftUI

// MARK: - Character

struct Character: Identifiable {
    var id: Int
    var avatarURLString: String
    var name: String
    var status: CharacterStatus
    var species: String
    var type: String
    var gender: String
    var episodes: [String]
    var lastKnownLocation: Location
}

// MARK: - CharacterStatus

enum CharacterStatus: String {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "Unknown"
    
    static func getStatus(by status: String) -> CharacterStatus {
        switch status {
            case CharacterStatus.alive.rawValue:
                return .alive
            case CharacterStatus.dead.rawValue:
                return .dead
            default:
                return .unknown
        }
    }
    
    func getStatusColor() -> Color {
        switch self {
            case .alive:
                return Color("GreenStateColor")
            case .dead:
                return Color("RedStateColor")
            case .unknown:
                return Color("UnknownStateColor")
        }
    }
}

// MARK: - CharactersResponse

struct CharactersResponse: Decodable {
    let info: Info
    let results: [CharacterResult]
}

// MARK: - Info

struct Info: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

// MARK: - CharacterResult

struct CharacterResult: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Location
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

// MARK: - Location

struct Location: Decodable {
    let name: String
    let url: String
}
