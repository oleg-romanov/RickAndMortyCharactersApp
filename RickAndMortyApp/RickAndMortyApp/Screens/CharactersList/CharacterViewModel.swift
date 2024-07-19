//
//  CharacterViewModel.swift
//  RickAndMortyApp
//
//  Created by Олег Романов on 17.07.2024.
//

import SwiftUI

@MainActor
class CharacterViewModel: ObservableObject {
    
    // MARK: Instance Properties
    
    @Published var characters = [Character]()
    @Published var searchText: String = ""
    
    var filteredCharacters: [Character] {
        guard !searchText.isEmpty else { return characters }
        return characters.filter { character in
            character.name.lowercased().contains(searchText.lowercased())
        }
    }
    
    private let networkService: APIClient
    
    private var nextPage: Int? = 1
    var isMoreDataAvaliable: Bool = false
    
    // MARK: Initializers
    
    init() {
        networkService = APIClient(baseURL: URL(string: APIConstants.baseURL))
    }
    
    // MARK: Instance Methods
    
    func fetchCharacters() async {
        await fetchMoreCharacters()
    }
    
    func fetchMoreCharacters() async {
        guard let nextPage = nextPage else { return }
        
        do {
            let charactersResponse: CharactersResponse = try await networkService.send(Request(path: "/character", query: ["page": "\(nextPage)"])).value
            
            let moreCharacters = charactersResponse.results.map { characterResult in
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
            
            characters.append(contentsOf: moreCharacters)
            
            if let nextPageURL = charactersResponse.info.next, let nextPage = extractPage(from: nextPageURL) {
                self.nextPage = nextPage
                isMoreDataAvaliable = true
            } else {
                self.nextPage = nil
                isMoreDataAvaliable = false
            }
            
        } catch {
            // TODO: Handle error
            print(error)
        }
    }
    
    private func extractPage(from urlString: String) -> Int? {
        guard let urlComponents = URLComponents(string: urlString) else {
            return nil
        }
        
        if let queryItems = urlComponents.queryItems {
            for item in queryItems {
                if item.name == "page", let value = item.value, let pageNumber = Int(value) {
                    return pageNumber
                }
            }
        }
        return nil
    }
}
