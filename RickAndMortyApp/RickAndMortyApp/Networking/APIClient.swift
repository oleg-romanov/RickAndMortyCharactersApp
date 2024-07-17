//
//  APIClient.swift
//  RickAndMortyApp
//
//  Created by Олег Романов on 17.07.2024.
//

import Foundation

final actor APIClient {
    
    // MARK: Instance Properties
    
    nonisolated let configuration: Configuration
    
    private let session: URLSession
    
    private let decoder: JSONDecoder
    
    struct Configuration {
        var baseURL: URL?
        var sessionConfiguration: URLSessionConfiguration = .default
        var decoder: JSONDecoder
        
        init(baseURL: URL? = nil, sessionConfiguration: URLSessionConfiguration = .default) {
            self.baseURL = baseURL
            self.sessionConfiguration = sessionConfiguration
            self.decoder = JSONDecoder()
            self.decoder.dateDecodingStrategy = .iso8601
        }
    }
    
    // MARK: Initializers
    
    init(baseURL: URL?, _ configure: @Sendable (inout APIClient.Configuration) -> Void = {_ in }) {
        var configuration = Configuration(baseURL: baseURL)
        configure(&configuration)
        self.init(configuration: configuration)
    }
    
    init(configuration: Configuration) {
        self.configuration = configuration
        self.session = URLSession(configuration: configuration.sessionConfiguration)
        self.decoder = configuration.decoder
    }
    
    // MARK: Instance Methods
    
    @discardableResult func send<T: Decodable>(_ request: Request, configure: ((inout URLRequest) throws -> Void)? = nil) async throws -> Response<T> {
        let response = try await data(for: request, configure: configure)
        let value: T = try await decode(response.data, using: decoder)
        return response.map { _ in value }
    }
    
    func data(for request: Request, configure: ((inout URLRequest) throws -> Void)? = nil) async throws -> Response<Data> {
        let request = try await makeURLRequest(for: request, configure)
        
        return try await performRequest {
            let (data, response) = try await session.data(for: request)
            try validate(response)
            
            return Response(value: data, response: response, data: data)
        }
    }
    
    private func makeURLRequest(
        for request: Request,
        _ configure: ((inout URLRequest) throws -> Void)?
    ) async throws -> URLRequest {
        let url = try makeURL(for: request)
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpMethod = request.method.rawValue
        
        if urlRequest.value(forHTTPHeaderField: "Accept") == nil &&
            session.configuration.httpAdditionalHeaders?["Accept"] == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        }
        if let configure = configure {
            try configure(&urlRequest)
        }
        return urlRequest
    }
    
    private func makeURL(for request: Request) throws -> URL {
        func makeURL() -> URL? {
            guard let url = request.url else {
                return nil
            }
            return url.scheme == nil ? configuration.baseURL?.appendingPathComponent(url.absoluteString) : url
        }
        
        guard let url = makeURL(), var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw URLError(.badURL)
        }
        
        if let query = request.query, !query.isEmpty {
            components.queryItems = query.map(URLQueryItem.init)
        }
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        return url
    }
    
    private func performRequest<T>(send: () async throws -> T) async throws -> T {
        do {
            return try await send()
        } catch {
            // TODO: Retry request for the connection error
            throw error
        }
    }
    
    // MARK: Helpers
    
    private func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.incorrectResponse
        }
        
        switch httpResponse.statusCode {
            case 200...299:
                return
            case 401:
                throw APIError.invalidAPIKey
            case 404:
                throw APIError.badRequest
            case 429:
                throw APIError.tooManyRequests
            case 500...599:
                throw APIError.serverError
            default:
                throw APIError.unacceptableStatusCode(httpResponse.statusCode)
        }
    }
    
    func decode<T: Decodable>(_ data: Data, using decoder: JSONDecoder) async throws -> T {
        if T.self == Data.self {
            return data as! T
        } else if T.self == String.self {
            guard let string = String(data: data, encoding: .utf8) else {
                throw URLError(.badServerResponse)
            }
            return string as! T
        } else {
            return try await Task.detached {
                try decoder.decode(T.self, from: data)
            }.value
        }
    }
}
