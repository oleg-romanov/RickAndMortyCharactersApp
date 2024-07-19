//
//  FilterButtonStyle.swift
//  RickAndMortyApp
//
//  Created by Олег Романов on 19.07.2024.
//

import SwiftUI

struct FilterButtonStyle: ViewModifier {
    var isActive: Bool = false
    var fontSize: CGFloat
    var height: CGFloat
    
    func body(content: Content) -> some View {
        HStack (spacing: 8) {
            HStack {
                content
                    .minimumScaleFactor(0.4)
                    .lineLimit(1)
                if (isActive) {
                    Image("CheckMarkIcon")
                }
            }
            .frame(height: height)
            .padding(.horizontal, 16)
            .font(.custom("IBMPlexSans-Regular", size: fontSize))
            .foregroundStyle(isActive ? Color(ColorConstant.backgroundColor) : Color(ColorConstant.mainTextColor))
            .background(isActive ? Color(ColorConstant.mainTextColor) : Color.clear)
            
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isActive ? Color(ColorConstant.mainTextColor) : Color(ColorConstant.darkGrayColor), lineWidth: 2)
                
            )
        }
    }
    
}

extension View {
    func filterButtonStyle(isActive: Bool, fontSize: CGFloat = 12, height: CGFloat = 36) -> some View {
        modifier(FilterButtonStyle(isActive: isActive, fontSize: fontSize, height: height))
    }
}

#Preview {
    Button {
        
    } label: {
        Text("Apple")
        
    }.filterButtonStyle(isActive: true)
    
}
