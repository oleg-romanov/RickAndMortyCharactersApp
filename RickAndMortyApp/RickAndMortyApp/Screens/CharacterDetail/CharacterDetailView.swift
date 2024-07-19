//
//  CharacterDetailView.swift
//  RickAndMortyApp
//
//  Created by Олег Романов on 18.07.2024.
//

import SwiftUI

struct CharacterDetailView: View {
    
    @StateObject var viewModel: CharacterDetailViewModel
    
    var body: some View {
        let character = viewModel.character
        ZStack {
            Color(ColorConstant.backgroundColor).ignoresSafeArea(.all)
            ScrollView {
                Group {
                    VStack(spacing: 12) {
                        let imageURL = URL(string: character.avatarURLString)
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.gray))
                                .controlSize(.large)
                        }
                        .frame(width: 320, height: 320)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        
                        let status = character.status
                        Text(status.rawValue)
                            .font(.custom("IBMPlexSans-SemiBold", size: 16))
                            .frame(maxWidth: .infinity, maxHeight: 42)
                            .frame(minHeight: 42)
                            .foregroundStyle(Color(ColorConstant.mainTextColor))
                            .background(status.getStatusColor())
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal, 16)
                        
                        VStack (alignment: .leading, spacing: 12) {
                            CharacterDescriptionText(
                                attribute: "Species: ",
                                attributeValue: character.species,
                                attributeFont: .custom("IBMPlexSans-SemiBold", size: 16),
                                attributeValueFont: .custom("IBMPlexSans-Regular", size: 16)
                            )
                            CharacterDescriptionText(
                                attribute: "Gender: ",
                                attributeValue: character.gender.rawValue,
                                attributeFont: .custom("IBMPlexSans-SemiBold", size: 16),
                                attributeValueFont: .custom("IBMPlexSans-Regular", size: 16)
                            )
                            CharacterDescriptionText(
                                attribute: "Episodes: ",
                                attributeValue: viewModel.episodesString,
                                attributeFont: .custom("IBMPlexSans-SemiBold", size: 16),
                                attributeValueFont: .custom("IBMPlexSans-Regular", size: 16)
                            )
                            CharacterDescriptionText(
                                attribute: "Last known location: ",
                                attributeValue: character.lastKnownLocation.name,
                                attributeFont: .custom("IBMPlexSans-SemiBold", size: 16),
                                attributeValueFont: .custom("IBMPlexSans-Light", size: 16)
                            )
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .padding(.bottom, 16)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .background(Color(ColorConstant.secondaryColor))
                }
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .onAppear {
                    Task {
                        await viewModel.fetchEpisodes()
                    }
                }
            }
        }
        .navigationTitle(character.name)
        .toolbarRole(.editor)
    }
}

#Preview {
    CharacterDetailView(viewModel: CharacterDetailViewModel(
        Character(
            id: 2,
            avatarURLString: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            name: "Rick Sanchez",
            status: CharacterStatus.getStatus(by: "Alive"),
            species: "Human",
            type: "",
            gender: CharacterGender.getGender(by: "Male"),
            episodes: [
                "https://rickandmortyapi.com/api/episode/1",
                "https://rickandmortyapi.com/api/episode/2",
            ],
            lastKnownLocation:
                Location(
                    name: "Earth (Replacement Dimension)",
                    url: "https://rickandmortyapi.com/api/location/20"
                )
        )
    ))
}

struct CharacterDescriptionText: View {
    
    var attribute: String
    var attributeValue: String
    var attributeFont: Font
    var attributeValueFont: Font
    
    var body: some View {
        HStack {
            Text(attribute)
                .font(attributeFont)
            +
            Text(attributeValue).font(attributeValueFont)
            Spacer()
        }
        .foregroundStyle(Color(ColorConstant.mainTextColor))
    }
}
