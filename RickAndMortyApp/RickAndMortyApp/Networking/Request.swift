//
//  Request.swift
//  RickAndMortyApp
//
//  Created by Олег Романов on 17.07.2024.
//

import Foundation

struct Request {
    
    // MARK: Instance Properties
    
    var url: URL?
    var method: HTTPMethod
    var query: [String: String]?
    var body: Encodable?
    var headers: [String: String]?
    
    // MARK: Initializers
    
    init(
        url: URL? = nil,
        method: HTTPMethod,
        query: [String : String]? = nil,
        body: Encodable? = nil,
        headers: [String : String]? = nil
    ) {
        self.url = url
        self.method = method
        self.query = query
        self.body = body
        self.headers = headers
    }
    
    init(
        path: String,
        method: HTTPMethod = .get,
        query: [String: String]? = nil,
        body: Encodable? = nil,
        headers: [String: String]? = nil
    ) {
        self.url = URL(string: path.isEmpty ? "/" : path)
        self.method = method
        self.query = query
        self.body = body
        self.headers = headers
    }
}

struct HTTPMethod: RawRepresentable, Hashable, ExpressibleByStringLiteral {
    
    let rawValue: String
    
    // MARK: Initializers
    
    init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    init(stringLiteral value: StringLiteralType) {
        self.rawValue = value
    }
    
    static let get: HTTPMethod = "GET"
}
