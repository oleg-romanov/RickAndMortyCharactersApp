//
//  CharactersListView.swift
//  RickAndMortyApp
//
//  Created by Олег Романов on 17.07.2024.
//

import SwiftUI

struct CharactersListView: View {
    
    @ObservedObject var viewModel = CharacterViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundColor").ignoresSafeArea(.all)
                
                VStack {
                    Spacer()
                    Text("Rick & Morty Characters")
                        .font(.custom("IBMPlexSans-Bold", size: 24))
                        .foregroundStyle(Color("MainTextColor"))
                        .frame(maxHeight: 31)
                        .padding(.bottom, 20)
                        .padding(.top, 12)
                    
                    List(viewModel.characters) { character in
                        CharacterRow(character: character)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                            .listRowInsets(.init(top: 0, leading: 20, bottom: 4, trailing: 20))
                            .listRowSeparator(.hidden)
                            .background(.clear)
                        
                        
                    }
                    .background(Color.clear)
                    .ignoresSafeArea()
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                    .task {
                        await viewModel.fetchCharacters()
                    }
                }
            }
            
        }
    }
}

#Preview {
    CharactersListView()
}
