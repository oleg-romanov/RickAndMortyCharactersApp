//
//  CharacterRow.swift
//  RickAndMortyApp
//
//  Created by Олег Романов on 17.07.2024.
//

import SwiftUI

struct CharacterRow: View {
    
    var character: Character
    
    var body: some View {
        HStack(spacing: 16) {
            let imageURL = URL(string: character.avatarURLString)
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            } placeholder: {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.gray))
            }
            .frame(width: 84, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(character.name)
                    .font(.custom("IBMPlexSans-Medium", size: 18))
                    .foregroundStyle(Color("MainTextColor"))
                    .frame(maxHeight: 18)
                    .lineLimit(1)
                
                Group {
                    Text(character.status.rawValue)
                        .foregroundStyle(character.status.getStatusColor())
                    +
                    Text(" • ")
                        .foregroundStyle(Color("MainTextColor"))
                    +
                    Text(character.species)
                        .foregroundStyle(Color("MainTextColor"))
                }
                .font(.custom("IBMPlexSans-SemiBold", size: 12))
                .frame(maxHeight: 16)
                
                Text(character.gender.rawValue)
                    .font(.custom("IBMPlexSans-Regular", size: 12))
                    .foregroundStyle(Color("MainTextColor"))
                    .frame(maxHeight: 16)
            }
            Spacer()
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(Color("SecondaryColor"))
        .listRowBackground(Color.clear)
    }
}

#Preview {
    CharacterRow(character: Character(
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
        lastKnownLocation: Location(
            name: "Earth (Replacement Dimension)",
            url: "https://rickandmortyapi.com/api/location/20"
        )
    ))
}
