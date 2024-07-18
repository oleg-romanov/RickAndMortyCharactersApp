//
//  CharacterViewModel.swift
//  RickAndMortyApp
//
//  Created by Олег Романов on 17.07.2024.
//

import SwiftUI

@MainActor
class CharacterViewModel: ObservableObject {
    
    @Published var characters = [Character]()
    
    private let networkService: APIClient
    
    init() {
        networkService = APIClient(baseURL: URL(string: APIConstants.baseURL))
    }
    
    func fetchCharacters() async {
        do {
            let charactersResponse: CharactersResponse = try await networkService.send(Request(path: "/character")).value
            characters = charactersResponse.results.map { characterResult in
                return Character(
                    id: characterResult.id,
                    avatarURLString: characterResult.image,
                    name: characterResult.name,
                    status: CharacterStatus.getStatus(by: characterResult.status),
                    species: characterResult.species,
                    type: characterResult.type,
                    gender: characterResult.gender,
                    episodes: characterResult.episode,
                    lastKnownLocation: characterResult.location
                )
            }
        } catch {
            // TODO: Handle error
            print(error)
        }
    }
}
