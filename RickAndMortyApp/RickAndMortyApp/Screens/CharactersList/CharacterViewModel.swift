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
    @Published var textEditingIsFinished: Bool = false {
        willSet {
            if newValue {
                Task {
                    await fetchCharacters()
                }
            }
        }
    }
    @Published var resetAllTapped: Bool = false {
        willSet {
            if newValue {
                isFilterApplied = false
                resetFilters()
            }
        }
    }
    @Published var isFilterTapped: Bool = false
    @Published var showFilterSheet = false
    @Published var selectedStatus: String = ""
    @Published var selectedGender: String = ""
    @Published var isFilterApplied: Bool = false
    
    private let networkService: APIClient
    private var nextPage: Int? = 1
    var isMoreDataAvaliable: Bool = false
    
    private var queries: [String : String] = [:]
    
    // MARK: Initializers
    
    init() {
        networkService = APIClient(baseURL: URL(string: APIConstants.baseURL))
    }
    
    // MARK: Instance Methods
    
    func fetchCharacters() async {
        createQueryParameters()
        
        do {
            let charactersResponse: CharactersResponse = try await networkService.send(Request(path: "/character", query: queries)).value
            
            let newCharacters = charactersResponse.results.map { characterResult in
                return Character(
                    id: characterResult.id,
                    avatarURLString: characterResult.image,
                    name: characterResult.name,
                    status: CharacterStatus.getStatus(by: characterResult.status),
                    species: characterResult.species,
                    type: characterResult.type,
                    gender: CharacterGender.getGender(by: characterResult.gender),
                    episodes: characterResult.episode,
                    lastKnownLocation: characterResult.location
                )
            }
            
            characters = newCharacters
            
            if let nextPageURL = charactersResponse.info.next, let nextPage = extractPage(from: nextPageURL) {
                self.nextPage = nextPage
                isMoreDataAvaliable = true
            } else {
                self.nextPage = nil
                isMoreDataAvaliable = false
            }
            
        } catch {
            // TODO: Handle error
            print(error.localizedDescription)
        }
    }
    
    func fetchMoreCharacters() async {
        guard let nextPage = nextPage else {
            return
        }
        
        queries["page"] = "\(nextPage)"
        do {
            let charactersResponse: CharactersResponse = try await networkService.send(Request(path: "/character", query: queries)).value
            
            let moreCharacters = charactersResponse.results.map { characterResult in
                return Character(
                    id: characterResult.id,
                    avatarURLString: characterResult.image,
                    name: characterResult.name,
                    status: CharacterStatus.getStatus(by: characterResult.status),
                    species: characterResult.species,
                    type: characterResult.type,
                    gender: CharacterGender.getGender(by: characterResult.gender),
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
    
    private func createQueryParameters() {
        queries = [:]
        if !searchText.isEmpty {
            queries["name"] = searchText
        }
        if !selectedStatus.isEmpty {
            queries["status"] = selectedStatus
        }
        if !selectedGender.isEmpty {
            queries["gender"] = selectedGender
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
    
    func applyFilters(status: String, gender: String) {
        self.selectedStatus = status
        self.selectedGender = gender
        self.isFilterApplied = true
        isMoreDataAvaliable = false
        nextPage = 1
        Task {
            await fetchCharacters()
        }
    }
    
    func resetFilters() {
        self.selectedStatus = ""
        self.selectedGender = ""
        self.isFilterApplied = false
        isMoreDataAvaliable = false
        self.searchText = ""
        queries = [:]
        nextPage = 1
        Task {
            await fetchCharacters()
        }
    }
}
