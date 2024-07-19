//
//  SplashView.swift
//  RickAndMortyApp
//
//  Created by Олег Романов on 18.07.2024.
//

import SwiftUI

struct SplashView: View {
    
    @State private var isActive = false
    @State private var size: CGFloat = 1.0
    @State private var opacity = 0.5
    
    var body: some View {
        
        if isActive {
            ContentView()
        } else {
            ZStack {
                Image("RickAndMortyBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                Image("RickAndMortyLogo")
                    .padding(.bottom, 16)
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(Animation.easeIn(duration: 1.2).repeatForever(autoreverses: true)) {
                            self.size = 1.2
                            self.opacity = 1.0
                        }
                    }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}


#Preview {
    SplashView()
}
