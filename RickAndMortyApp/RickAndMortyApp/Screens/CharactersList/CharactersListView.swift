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
                Color(ColorConstant.backgroundColor).ignoresSafeArea(.all)
                
                VStack {
                    SearchBar(
                        text: $viewModel.searchText,
                        isFilterTapped: $viewModel.isFilterTapped,
                        resetAllTapped: $viewModel.resetAllTapped, 
                        selectedStatus: $viewModel.selectedStatus,
                        selectedGender: $viewModel.selectedGender,
                        textEditingIsFinished: $viewModel.textEditingIsFinished
                    )
                    .onChange(of: viewModel.isFilterTapped) { _, newValue in
                        if newValue {
                            viewModel.showFilterSheet = true
                            viewModel.isFilterTapped = false
                        }
                    }
                    .padding(.top, 6)
                    .padding(.horizontal, 20)
                    List {
                        ForEach(viewModel.characters) { character in
                            
                            CharacterRow(character: character)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                .listRowInsets(.init(top: 0, leading: 20, bottom: 4, trailing: 20))
                                .listRowSeparator(.hidden)
                                .background(
                                    NavigationLink("", destination: CharacterDetailView(viewModel: CharacterDetailViewModel(character)))
                                        .opacity(0)
                                )
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
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                    .padding(.top)
                    .font(.custom("IBMPlexSans-Regular", size: 14))
                    .foregroundStyle(Color(ColorConstant.mainTextColor))
                    .onAppear {
                        Task {
                            await viewModel.fetchCharacters()
                        }
                    }
                }
                .sheet(isPresented: $viewModel.showFilterSheet, onDismiss: {
                    viewModel.isFilterTapped = false
                }, content: {
                    FilterView(
                        selectedStatus: $viewModel.selectedStatus,
                        selectedGender: $viewModel.selectedGender,
                        isFilterApplied: $viewModel.isFilterApplied) {
                            viewModel.applyFilters(status: viewModel.selectedStatus, gender: viewModel.selectedGender)
                            viewModel.showFilterSheet = false
                        } onClose: {
                            viewModel.showFilterSheet = false
                        }
                        .presentationDetents([.height(312)])
                })
            }
            .navigationTitle("Rick & Morty Characters")
            .navigationBarTitleDisplayMode(.inline)
        }
        .tint(Color(ColorConstant.mainTextColor))
        
    }
    
    private var lastRowView: some View {
        ZStack {
            Color(ColorConstant.backgroundColor).ignoresSafeArea(.all)
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
