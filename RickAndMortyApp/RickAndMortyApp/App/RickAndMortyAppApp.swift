//
//  RickAndMortyAppApp.swift
//  RickAndMortyApp
//
//  Created by Олег Романов on 17.07.2024.
//

import SwiftUI

@main
struct RickAndMortyAppApp: App {
    
    init() {
        let appear = UINavigationBarAppearance()
        
        let atters: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "IBMPlexSans-Bold", size: 24)!,
            .foregroundColor: UIColor(named: "MainTextColor")!,
        ]
        
        appear.largeTitleTextAttributes = atters
        appear.titleTextAttributes = atters
        appear.backgroundColor = UIColor(named: "BackgroundColor")!
        
        UINavigationBar.appearance().standardAppearance = appear
        UINavigationBar.appearance().compactAppearance = appear
        UINavigationBar.appearance().scrollEdgeAppearance = appear
    }
    
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}
