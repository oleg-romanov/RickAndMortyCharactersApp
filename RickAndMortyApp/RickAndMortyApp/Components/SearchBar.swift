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
    @Binding var isFilterTapped: Bool
    @Binding var resetAllTapped: Bool
    @Binding var selectedStatus: String
    @Binding var selectedGender: String
    @Binding var textEditingIsFinished: Bool
    
    
    var body: some View {
        VStack (alignment: .leading) {
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
                            textEditingIsFinished = true
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
                        textEditingIsFinished = true
                        withAnimation {
                            showCancelButton = false
                        }
                    })
                } else {
                    Button {
                        isFilterTapped = true
                    } label: {
                        Image(!selectedStatus.isEmpty || !selectedGender.isEmpty ? "FiltersActive" : "Filters")
                        
                    }
                }
            }
            if !selectedStatus.isEmpty || !selectedGender.isEmpty {
                HStack {
                    if !selectedStatus.isEmpty {
                        Text(selectedStatus)
                            .frame(height: 24)
                            .padding(.horizontal, 16)
                            .font(.custom("IBMPlexSans-Regular", size: 8))
                            .background(Color("MainTextColor"))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .foregroundStyle(Color("BackgroundColor"))
                    }
                    if !selectedGender.isEmpty {
                        Text(selectedGender)
                            .frame(height: 24)
                            .padding(.horizontal, 16)
                            .font(.custom("IBMPlexSans-Regular", size: 8))
                            .background(Color("MainTextColor"))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .foregroundStyle(Color("BackgroundColor"))
                    }
                    Button {
                        selectedStatus = ""
                        selectedGender = ""
                        resetAllTapped = true
                    } label: {
                        Text("Reset all filters")
                        
                    }
                    .frame(height: 24)
                    .padding(.horizontal, 16)
                    .font(.custom("IBMPlexSans-Regular", size: 8))
                    .background(Color("ActiveStateColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .foregroundStyle(Color("MainTextColor"))
                }
                
            }
        }
    }
}
