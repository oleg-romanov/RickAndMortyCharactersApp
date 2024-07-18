//
//  CharacterDetailViewModel.swift
//  RickAndMortyApp
//
//  Created by Олег Романов on 18.07.2024.
//

import SwiftUI

@MainActor
class CharacterDetailViewModel: ObservableObject {
    
    // MARK: Instance Properties
    
    @Published var episodesString = ""
    
    var character: Character
    
    private let networkService: APIClient
    
    // MARK: Initializers
    
    init(_ character: Character) {
        networkService = APIClient(baseURL: URL(string: APIConstants.baseURL))
        self.character = character
    }
    
    // MARK: Instance Methods
    
    func fetchEpisodes() async {
        let episodesIds = extractEpisodes(from: character.episodes)
        let episodesSequence = getStringSequence(from: episodesIds, separator: ",")
        do {
            let episodesResponse: EpisodesResponse = try await networkService.send(Request(path: "/episode/" + episodesSequence)).value
            let episodesName = episodesResponse.map { $0.name }
            episodesString = getStringSequence(from: episodesName, separator: ", ")
        } catch {
            // TODO: Handle error
            print(error)
        }
    }
    
    private func getStringSequence<T: CustomStringConvertible>(from elements: [T], separator: String) -> String {
        return elements.map { $0.description }.joined(separator: separator)
    }
    
    private func extractEpisodes(from urlStrings: [String]) -> [Int] {
        var episodesIds: [Int] = []
        
        urlStrings.forEach { urlString in
            let components = urlString.split(separator: "/")
            
            guard
                let lastComponent = components.last,
                let episodeId = Int(String(lastComponent))
            else {
                return
            }
            
            episodesIds.append(episodeId)
        }
        return episodesIds
    }
}

