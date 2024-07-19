//
//  View+Extensions.swift
//  RickAndMortyApp
//
//  Created by Олег Романов on 19.07.2024.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
