//
//  SearchBar.swift
//  RickAndMortyApp
//
//  Created by Олег Романов on 19.07.2024.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @State var showCancelButton = false
    
    var body: some View {
        HStack (spacing: 16) {
            HStack (spacing: 7) {
                Image("SearchIcon")
                TextField("",
                          text: $text,
                          prompt: Text("Search").font(.custom("IBMPlexSans-Regular", size: 14)).foregroundStyle(Color("MainTextColor"))
                )
                .foregroundStyle(Color("MainTextColor"))
                .onSubmit {
                    withAnimation {
                        showCancelButton = false
                    }
                }
                .onTapGesture {
                    withAnimation {
                        showCancelButton = true
                    }
                }
            }
            .frame(height: 40)
            .padding(.horizontal, 13)
            .background(Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color("DarkGrayColor"), lineWidth: 2)
            )
            if showCancelButton {
                Button("Cancel", action: {
                    hideKeyboard()
                    text = ""
                    withAnimation {
                        showCancelButton = false
                    }
                })
            } else {
                Button {
                    // TODO: Filter tap handler
                } label: {
                    Image("Filters")
                }
            }
        }
    }
}
