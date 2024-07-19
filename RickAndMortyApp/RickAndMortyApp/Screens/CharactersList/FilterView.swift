//
//  FilterView.swift
//  RickAndMortyApp
//
//  Created by Олег Романов on 19.07.2024.
//

import SwiftUI

struct FilterView: View {
    
    @Binding var selectedStatus: String
    @Binding var selectedGender: String
    @Binding var isFilterApplied: Bool
    
    @State private var tempSelectedStatus: String
    @State private var tempSelectedGender: String
    
    var onApply: () -> Void
    var onClose: () -> Void?
    
    init(selectedStatus: Binding<String>, selectedGender: Binding<String>, isFilterApplied: Binding<Bool>, onApply: @escaping () -> Void, onClose: @escaping () -> Void) {
        _selectedStatus = selectedStatus
        _selectedGender = selectedGender
        _isFilterApplied = isFilterApplied
        self.onApply = onApply
        self.onClose = onClose
        
        _tempSelectedStatus = State(initialValue: selectedStatus.wrappedValue)
        _tempSelectedGender = State(initialValue: selectedGender.wrappedValue)
    }
    
    var body: some View {
        ZStack {
            Color("SecondaryColor").ignoresSafeArea(.all)
            VStack (alignment: .leading, spacing: 24) {
                HStack {
                    Button {
                        isFilterApplied = false
                        onClose()
                    } label: {
                        Image("CloseIcon")
                    }
                    Spacer()
                    
                    Text("Filters")
                        .font(.custom("IBMPlexSans-Semibold", size: 20))
                    
                    Spacer()
                    Button {
                        isFilterApplied = false
                        tempSelectedStatus = ""
                        tempSelectedGender = ""
                        
                    } label: {
                        Text("Reset")
                            .font(.custom("IBMPlexSans-Regular", size: 14))
                            .foregroundStyle(!tempSelectedStatus.isEmpty || !tempSelectedGender.isEmpty ? Color("ActiveStateColor") : Color("MainTextColor"))
                    }
                }
                .padding(.top, 24)
                
                VStack (alignment: .leading) {
                    Text("Status")
                        .font(.custom("IBMPlexSans-Medium", size: 14))
                    HStack {
                        ForEach(CharacterStatus.allCases, id: \.self) { status in
                            Button {
                                tempSelectedStatus = status.rawValue
                            } label: {
                                Text(status.rawValue)
                            }
                            .filterButtonStyle(isActive: tempSelectedStatus == status.rawValue)
                        }
                    }
                }
                
                VStack (alignment: .leading) {
                    Text("Gender")
                        .font(.custom("IBMPlexSans-Medium", size: 14))
                    
                    HStack {
                        ForEach(CharacterGender.allCases, id: \.self) { gender in
                            Button {
                                tempSelectedGender = gender.rawValue
                            } label: {
                                Text(gender.rawValue)
                            }
                            .filterButtonStyle(isActive: tempSelectedGender == gender.rawValue)
                        }
                    }
                    
                }
                
                Button {
                    selectedStatus = tempSelectedStatus
                    selectedGender = tempSelectedGender
                    isFilterApplied = true
                    onApply()
                } label: {
                    Text("Apply")
                        .font(.custom("IBMPlexSans-Medium", size: 18))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 42)
                .background(Color("ActiveStateColor"))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Spacer()
            }
            .foregroundStyle(Color("MainTextColor"))
            .padding(.horizontal, 20)
        }
    }
}
