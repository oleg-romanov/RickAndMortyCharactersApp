//
//  CharactersListView.swift
//  RickAndMortyApp
//
//  Created by Олег Романов on 17.07.2024.
//

import SwiftUI

struct CharactersListView: View {
    
    @StateObject var viewModel = CharacterViewModel()
    
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
                    
                    List {
                        ForEach(viewModel.characters) { character in
                            CharacterRow(character: character)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                .listRowInsets(.init(top: 0, leading: 20, bottom: 4, trailing: 20))
                                .listRowSeparator(.hidden)
                                .background(Color.clear)
                            
                        }
                        
                        if viewModel.isMoreDataAvaliable {
                            lastRowView
                                .onAppear {
                                    Task {
                                        await viewModel.fetchMoreCharacters()
                                    }
                                }
                                .listRowInsets(EdgeInsets())
                        }
                    }
                    .background(Color.clear)
                    .ignoresSafeArea()
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                    .onAppear {
                        Task {
                            await viewModel.fetchCharacters()
                        }
                    }
                }
            }
            
        }
    }
    
    private var lastRowView: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea(.all)
            HStack(alignment: .center) {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.gray))
                    .controlSize(.large)
                    .padding(.top, 20)
                    .padding(.bottom, 75)
                    .ignoresSafeArea()
                Spacer()
            }
        }
    }
}

#Preview {
    CharactersListView()
}
