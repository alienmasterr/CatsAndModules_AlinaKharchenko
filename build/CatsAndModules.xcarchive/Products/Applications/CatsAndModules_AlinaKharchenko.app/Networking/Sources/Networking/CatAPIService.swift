//
//  CatAPIService.swift
//  Networking
//
//  Created by alina on 15.05.2026.
//

import Foundation

public protocol CatServiceProtocol {
    func getCats(limit: Int, animal: String) async throws -> [Cat]
}

// ідею енама з помилками підказав клод, мені сподобалось, я лишила
public enum NetworkingError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingFailed(Error)
    case serverError(Int)

    public var errorDescription: String? {
        switch self {
        case .invalidURL: return "Невірна URL адреса"
        case .invalidResponse: return "Сервер повернув невірну відповідь"
        case .decodingFailed: return "Не вдалося розпарсити дані"
        case .serverError(let code): return "Помилка сервера: \(code)"
        }
    }
}

public final class CatAPIService: CatServiceProtocol {

    private let baseURL = "https://api.thecatapi.com/v1"
    private let dogURL = "https://api.thedogapi.com/v1"

    private let session: URLSession

    private let apiKey: String

    public init(apiKey: String = "", session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }

    public func getCats(limit: Int = 23, animal: String = "CATS") async throws -> [Cat] {
        var theURL = baseURL
        if animal == "DOGS" {
            theURL = dogURL
        }
        guard var components = URLComponents(string: "\(theURL)/images/search")
        else {
            throw NetworkingError.invalidURL
        }

        components.queryItems = [
            URLQueryItem(name: "limit", value: "\(min(limit, 100))"),
            URLQueryItem(name: "has_breeds", value: "1"),
            URLQueryItem(name: "mime_types", value: "jpg,png"),
        ]

        guard let url = components.url else {
            throw NetworkingError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if !apiKey.isEmpty {
            request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkingError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkingError.serverError(httpResponse.statusCode)
        }

        do {
            let cats = try JSONDecoder().decode([Cat].self, from: data)
            return cats
        } catch {
            throw NetworkingError.decodingFailed(error)
        }
    }
}
