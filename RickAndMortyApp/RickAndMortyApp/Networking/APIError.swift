//
//  APIError.swift
//  RickAndMortyApp
//
//  Created by Олег Романов on 17.07.2024.
//

import Foundation

enum APIError: Error, LocalizedError {
    case unacceptableStatusCode(Int)
    case incorrectResponse
    case invalidAPIKey
    case badRequest
    case tooManyRequests
    case serverError
    
    public var errorDescription: String? {
        switch self {
            case .unacceptableStatusCode(let statusCode):
                return "Неожиданный статусный код ответа сервера \(statusCode)."
            case .incorrectResponse:
                return "Некорректный ответ сервера."
            case .invalidAPIKey:
                return "Неверный API ключ."
            case .badRequest:
                return "Ошибка запроса."
            case .tooManyRequests:
                return "Слишком много запросов."
            case .serverError:
                return "Внутренняя ошибка сервера."
        }
    }
}
