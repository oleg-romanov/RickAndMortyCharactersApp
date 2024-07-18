//
//  Response.swift
//  RickAndMortyApp
//
//  Created by Олег Романов on 17.07.2024.
//

import Foundation

struct Response<T> {
    
    // MARK: Instance Properties
    
    let value: T
    let response: URLResponse
    var statusCode: Int? { (response as? HTTPURLResponse)?.statusCode }
    let data: Data
    
    // MARK: Initializers
    
    init(value: T, response: URLResponse, data: Data) {
        self.value = value
        self.response = response
        self.data = data
    }
    
    // MARK: Instance Methods
    
    func map<E>(_ closure: (T) throws -> E) rethrows -> Response<E> {
        Response<E>(value: try closure(value), response: response, data: data)
    }
}
